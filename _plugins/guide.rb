require 'json'
require 'nokogiri'

# The user guide (_guide/, see GUIDE.md).
#
# - Generates a page per topic in _data/guide.yml at /docs/topics/<id>.html, and a page
#   per kind (tutorials, how-to guides, ...) at /docs/kinds/<slug>.html.
# - Collects the `apis` front matter into site.data['guide_classes'] for the A-Z index.
# - Writes /docs/search.json: a record per page and per ## section, for the search
#   in javascript/guide.js.
# - Warns about pages with an unknown topic or kind and about links to guide pages
#   that do not exist.
module WicketGuide
  KINDS = %w[tutorial howto reference explanation].freeze

  class TopicPage < Jekyll::PageWithoutAFile
    def initialize(site, topic)
      super(site, site.source, 'docs/topics', "#{topic['id']}.html")
      data['layout'] = 'guide-topic'
      data['title'] = topic['title']
      data['topic'] = topic['id']
      data['summary'] = topic['summary']
      data['active_link'] = 'documentation'
      self.content = ''
    end
  end

  class KindPage < Jekyll::PageWithoutAFile
    def initialize(site, kind)
      super(site, site.source, 'docs/kinds', "#{WicketGuide.kind_slug(kind)}.html")
      data['layout'] = 'guide-kind'
      data['title'] = kind['title']
      data['kind'] = kind['id']
      data['summary'] = kind['intro']
      data['active_link'] = 'documentation'
      self.content = ''
    end
  end

  # "How-to guides" -> "how-to-guides"
  def self.kind_slug(kind)
    kind['title'].downcase.gsub(/[^a-z0-9]+/, '-').gsub(/\A-|-\z/, '')
  end

  class Generator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      guide = site.collections['guide'] or return
      config = site.data['guide'] || {}
      topics = config['topics'] || []
      topic_ids = topics.map { |t| t['id'] }

      topics.each { |topic| site.pages << TopicPage.new(site, topic) }
      (config['kinds'] || []).each do |kind|
        kind['url'] = "/docs/kinds/#{WicketGuide.kind_slug(kind)}.html"
        site.pages << KindPage.new(site, kind)
      end

      classes = Hash.new { |h, k| h[k] = [] }
      guide.docs.each do |doc|
        name = doc.relative_path
        Jekyll.logger.warn 'Guide:', "#{name}: unknown topic '#{doc.data['topic']}'" unless topic_ids.include?(doc.data['topic'])
        Jekyll.logger.warn 'Guide:', "#{name}: unknown type '#{doc.data['type']}'" unless KINDS.include?(doc.data['type'])
        Jekyll.logger.warn 'Guide:', "#{name}: no summary" if doc.data['summary'].to_s.strip.empty?
        Array(doc.data['apis']).each { |api| classes[api.to_s] << doc }
      end

      site.data['guide_classes'] = classes.keys.sort_by(&:downcase).map do |api|
        { 'name' => api, 'letter' => api.sub(/\AI(?=[A-Z])/, '')[0].upcase,
          'pages' => classes[api].sort_by { |d| KINDS.index(d.data['type']) || 9 } }
      end

      # The oldest release line in service: pages for it need no version marker.
      lines = (site.data.dig('releases', 'lines') || []).select { |l| l['page'] && %w[lts current].include?(l['status']) }
      site.data['guide_oldest'] = lines.map { |l| l['series'].to_i }.min || 0
      site.data['guide_lines'] = lines.map { |l| l['series'].to_i }.uniq.sort
      # The next major release, announced but not out yet: pages and notes for it say so.
      boarding = (site.data.dig('releases', 'lines') || []).find { |l| l['status'] == 'boarding' }
      site.data['guide_upcoming'] = boarding && { 'series' => boarding['series'].to_i, 'when' => boarding['when'] }
    end
  end

  def self.records
    @records ||= []
  end

  def self.text(nodes)
    nodes.map(&:text).join(' ').gsub(/\s+/, ' ').strip
  end

  # Wicket class names mentioned in code within the nodes, e.g. AjaxLink, IModel.
  def self.identifiers(nodes)
    nodes.flat_map { |n| n.css('code').map(&:text) + (n.name == 'code' ? [n.text] : []) }
         .flat_map { |t| t.scan(/\b[A-Z][A-Za-z0-9]*[a-z][A-Za-z0-9]*\b/) }
         .uniq.first(30)
  end

  # Splits a rendered page into its intro and its ## sections.
  def self.index(doc, topics)
    html = Nokogiri::HTML::DocumentFragment.parse(doc.content)
    base = doc.site.config['baseurl'].to_s + doc.url
    topic = topics.find { |t| t['id'] == doc.data['topic'] } || {}
    common = { 'page' => doc.data['title'], 'kind' => doc.data['type'], 'topic' => topic['title'],
               'since' => doc.data['since'].to_i }

    sections = [[nil, []]]
    html.children.each do |node|
      if node.name == 'h2'
        sections << [node, []]
      else
        sections.last[1] << node
      end
    end

    intro = sections.shift[1]
    records << common.merge('id' => doc.url, 'url' => base, 'title' => doc.data['title'],
                            'text' => doc.data['summary'].to_s,
                            'keywords' => Array(doc.data['keywords']).join(' '),
                            'apis' => (Array(doc.data['apis']).map(&:to_s) + identifiers(intro)).uniq.join(' '),
                            'body' => text(intro))
    sections.each do |heading, nodes|
      next unless heading && heading['id']
      body = text(nodes)
      records << common.merge('id' => "#{doc.url}##{heading['id']}", 'url' => "#{base}##{heading['id']}",
                              'title' => heading.text.strip, 'text' => body[0, 160], 'keywords' => '',
                              'apis' => identifiers(nodes).join(' '), 'body' => body)
    end
  end
end

Jekyll::Hooks.register :site, :pre_render do |_site|
  WicketGuide.records.clear
end

Jekyll::Hooks.register :guide, :post_convert do |doc|
  WicketGuide.index(doc, doc.site.data.dig('guide', 'topics') || [])
end

Jekyll::Hooks.register :site, :post_write do |site|
  next unless site.collections['guide']
  dir = File.join(site.dest, 'docs')
  FileUtils.mkdir_p(dir)
  File.write(File.join(dir, 'search.json'), JSON.generate(WicketGuide.records.sort_by { |r| r['id'] }))

  # Links to guide pages that do not exist.
  base = site.config['baseurl'].to_s
  site.collections['guide'].docs.each do |doc|
    doc.output.to_s.scan(%r{href="#{Regexp.escape(base)}(/docs/[^"#?]+)}).flatten.uniq.each do |url|
      file = File.join(site.dest, url.end_with?('/') ? "#{url}index.html" : url)
      Jekyll.logger.warn 'Guide:', "#{doc.relative_path} links to missing #{url}" unless File.exist?(file)
    end
  end
end
