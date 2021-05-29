# Custom tag to render absolute urls to posts
#
# See:
#    - https://jekyllrb.com/docs/plugins/tags/
#    - https://github.com/jekyll/jekyll/blob/76517175e700d80706c9139989053f1c53d9b956/lib/jekyll/tags/post_url.rb
#    - https://github.com/jekyll/jekyll/blob/76517175e700d80706c9139989053f1c53d9b956/lib/jekyll/filters/url_filters.rb

module Jekyll
  class PostAbsoluteUrl < Jekyll::Tags::PostUrl

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      absolute_url("#{ super(context) }")
    end
  end
end

Liquid::Template.register_tag('post_absolute_url', Jekyll::PostAbsoluteUrl)
