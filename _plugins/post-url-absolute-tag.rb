# Custom tag to render absolute urls to posts.
# Similar to `{% post_url %}` but produces absolute urls.
#
# See:
#    - https://jekyllrb.com/docs/plugins/tags/
#    - https://github.com/jekyll/jekyll/blob/76517175e700d80706c9139989053f1c53d9b956/lib/jekyll/tags/post_url.rb
#    - https://github.com/jekyll/jekyll/blob/76517175e700d80706c9139989053f1c53d9b956/lib/jekyll/filters/url_filters.rb
#    - https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers

module Jekyll
  class PostUrlAbsolute < Jekyll::Tags::PostUrl

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    # Returns absolute url to a post
    def render(context)
      absolute_url("#{ super(context) }")
    end
  end
end

Liquid::Template.register_tag('post_url_absolute', Jekyll::PostUrlAbsolute)
