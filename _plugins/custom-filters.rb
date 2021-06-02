# Custom filters to render:
#    - post tag urls
#    - post category urls
#    - image asset urls
#
# All urls are relative, but can be made absolute using `{{ value | absolute_url }}`
#
# Examples:
#
# - Create relative post tag urls:
#    `{{ "macos" | tag_url }}`
#
# - Create relative post category urls:
#    `{{ "software-dev" | category_url }}`
#
# - Create relative image asset urls with (optional) subdirectory name:
#    `{{ "photo.jpg" | img_url }}`
#    `{{ "photo.jpg" | img_url: 'blog' }}`
#
# See:
#    - https://jekyllrb.com/docs/plugins/filters/
#    - https://github.com/jekyll/jekyll/blob/4fbbefeb7eecff17d877f14ee15cbf8b87a52a6e/lib/jekyll/filters.rb
#    - https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers

module Jekyll
  module CustomFilters

    # Returns url to an image asset. Specify an optional subdirectory name.
    def img_url(input, sub_directory_name = '')
      if !sub_directory_name.nil? && !sub_directory_name.empty?
        sub_directory_name.concat("/")
      end
      create_url("#{ sub_directory_name }#{ input }", 'img_url')
    end

    # Returns url to a post tag.
    def tag_url(input)
      create_url("#{ input }/", 'tags_url')
    end

    # Returns url to a post category.
    def category_url(input)
      create_url("#{ input }/", 'categories_url')
    end

    private

    def create_url(input, config_key)
      base_url = @context.registers[:site].config[config_key]

      if base_url.nil?
        abort "Cannot find site config value for key: #{ config_key }"
      end

      return "#{ base_url }#{ input }"
    end
  end
end

Liquid::Template.register_filter(Jekyll::CustomFilters)
