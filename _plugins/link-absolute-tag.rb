# Custom tag to render absolute urls to pages.
# Similar to `{% link %}` but produces absolute urls.
#
# See:
#    - https://jekyllrb.com/docs/plugins/tags/
#    - https://github.com/jekyll/jekyll/blob/76517175e700d80706c9139989053f1c53d9b956/lib/jekyll/tags/link.rb
#    - https://github.com/jekyll/jekyll/blob/76517175e700d80706c9139989053f1c53d9b956/lib/jekyll/filters/url_filters.rb
#    - https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers

module Jekyll
  class LinkAbsolute < Jekyll::Tags::Link

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    # Returns absolute url to a page/resource
    def render(context)
      absolute_url("#{ super(context) }")
    end
  end
end

Liquid::Template.register_tag('link_absolute', Jekyll::LinkAbsolute)
