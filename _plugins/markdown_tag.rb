module Jekyll
  class MarkdownTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
    end
    require "kramdown"
    def render(context)
      @f = File.read(File.join(Dir.pwd, @text))
      if @f =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
        @f = $POSTMATCH
      end

      "#{Kramdown::Document.new(@f).to_html}"
    end
  end
end
Liquid::Template.register_tag('markdown', Jekyll::MarkdownTag)
