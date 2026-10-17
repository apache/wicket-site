# encoding: utf-8
require 'nokogiri'

# Turns bare http(s) URLs in rendered HTML into links. Release announcements list their
# download and changelog URLs as plain text; Kramdown leaves those unlinked.
# Text inside links, code and preformatted blocks is left alone.
module Jekyll
  module AutolinkFilter
    URL = %r{https?://[^\s<>"')\]]+}
    SKIP = %w[a code pre script style].freeze

    def autolink(html)
      return html unless html.to_s.include?('http')
      doc = Nokogiri::HTML::DocumentFragment.parse(html)
      doc.xpath('.//text()').each do |node|
        next unless node.text =~ URL
        next if node.ancestors.any? { |a| SKIP.include?(a.name) }
        linked = node.text.gsub(URL) do |url|
          trail = url[/[.,;:!?]+\z/] || ''
          url = url[0...(url.length - trail.length)]
          %(<a href="#{url}">#{url}</a>#{trail})
        end
        node.replace(Nokogiri::HTML::DocumentFragment.parse(escape_text(linked)))
      end
      doc.to_html
    end

    private

    # The text node's content is plain text; escape it before parsing, except the links just made.
    def escape_text(linked)
      linked.split(/(<a href="[^"]*">[^<]*<\/a>)/).map.with_index do |part, i|
        i.odd? ? part : CGI.escapeHTML(part)
      end.join
    end
  end
end

Liquid::Template.register_filter(Jekyll::AutolinkFilter)
