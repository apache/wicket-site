# encoding: utf-8
require 'nokogiri'

# Turns bare http(s) URLs and CVE identifiers in rendered HTML into links. Release
# announcements list their download URLs and the CVEs they fix as plain text.
# Text inside links, code and preformatted blocks is left alone.
module Jekyll
  module AutolinkFilter
    URL = %r{https?://[^\s<>"')\]]+}
    CVE = /\bCVE-\d{4}-\d{4,}\b/
    LINKABLE = Regexp.union(URL, CVE)
    SKIP = %w[a code pre script style].freeze

    def autolink(html)
      return html unless html.to_s =~ LINKABLE
      doc = Nokogiri::HTML::DocumentFragment.parse(html)
      doc.xpath('.//text()').each do |node|
        next unless node.text =~ LINKABLE
        next if node.ancestors.any? { |a| SKIP.include?(a.name) }
        linked = node.text.gsub(LINKABLE) do |match|
          if match.start_with?('CVE-')
            %(<a href="https://www.cve.org/CVERecord?id=#{match}">#{match}</a>)
          else
            trail = match[/[.,;:!?]+\z/] || ''
            url = match[0...(match.length - trail.length)]
            %(<a href="#{url}">#{url}</a>#{trail})
          end
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
