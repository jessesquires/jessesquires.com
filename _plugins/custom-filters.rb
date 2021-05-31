# Custom filters to render post tag and post category urls.
# Examples:
#
# - Create relative and absolute post tag urls:
#    `{{ "macos" | tag_url }}`
#    `{{ "macos" | tag_url: true }}`
#
# - Create relative and absolute post category urls:
#    `{{ "software-dev" | category_url }}`
#    `{{ "software-dev" | category_url: true }}`
#
# See:
#    - https://jekyllrb.com/docs/plugins/filters/
#    - https://github.com/jekyll/jekyll/blob/4fbbefeb7eecff17d877f14ee15cbf8b87a52a6e/lib/jekyll/filters.rb
#    - https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers

module Jekyll
  module CustomFilters
    include Jekyll::Filters::URLFilters

    # Returns url to a post tag. Pass `true` to make absolute, `false` to make relative.
    def tag_url(input, is_absolute = false)
      create_url(input, 'tags_url', is_absolute)
    end

    # Returns url to a post category. Pass `true` to make absolute, `false` to make relative.
    def category_url(input, is_absolute = false)
      create_url(input, 'categories_url', is_absolute)
    end

    private

    def create_url(tag_name, config_key, is_absolute)
      base_url = @context.registers[:site].config[config_key]
      if base_url.nil?
        abort "Cannot find site config value for key: #{ config_key }"
      end
      relative_url = "#{ base_url }#{ tag_name }/"

      return is_absolute ? absolute_url("#{ relative_url }") : relative_url
    end
  end
end

Liquid::Template.register_filter(Jekyll::CustomFilters)
