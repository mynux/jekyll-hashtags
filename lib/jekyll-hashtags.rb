# frozen_string_literal: true

require 'jekyll'
require 'html/pipeline/hashtag/hashtag_filter'

module Jekyll
  class Hashtags
    HASH_TAG_SYMBOL = '#'
    DEFAULT_HASHTAG_BASE_URL = ''
    DEFAULT_HASHTAG_URL = '/tags/%{tag}'
    DEFAULT_HASHTAG_PATTERN = '/#([\p{L}\w\-]+)/'
    BODY_START_TAG = '<body'
    OPENING_BODY_TAG_REGEX = %r!<body(.*)>\s*!
    BODY_END_TAG = '</body>'

    class << self
      def hashtag_it(doc)
        content = doc.output
        return unless content.include?(HASH_TAG_SYMBOL)
        base_url = get_base_url(doc.site.config)
        if content.include? BODY_START_TAG
          head, opener, tail = content.partition(OPENING_BODY_TAG_REGEX)
          body, *rest = tail.partition(BODY_END_TAG)
          context = {
              "hashtag_pattern" => get_hashtag_pattern(doc.site.config),
              "tag_url" => get_tag_url(doc.site.config),
          }
          processed_markup = filter_with_hashtag(base_url, context).call(body)[:output].to_html
          doc.output = String.new(head) << opener << processed_markup << rest.join
        else
          doc.output = filter_with_hashtag(base_url, context).call(content)[:output].to_html
        end
      end

        # Public: Create or fetch the filter for the given {{src}} base URL.
        #
        # :doc
        # :base_url - the base URL (e.g. http://mynux.cn)
        #
        # Returns an HTML::Pipeline instance for the given base URL.
        #
      def filter_with_hashtag(base_url = DEFAULT_HASHTAG_BASE_URL, context = {})
        filters[base_url] ||= HTML::Pipeline.new([HTML::Pipeline::HashtagFilter],
                                                 context)
      end

      # Public: Filters hash where the key is the mention base URL.
      # Effectively a cache.
      def filters
        @filters ||= {}
      end

        # Public: Calculate the tag pattern to use for hashtag.
        # The custom tag patter can be defined in the config as
        # jekyll-hashtag.tag_pattern or jekyll-hashtags, and must
        # be a valid regex.
        #
        # config - the hash-like configuration of the document's site
        #
        # Returns a regex valid string to use as the tag pattern for hashtags.
        # Defaults is #{DEFAULT_HASHTAG_PATTERN}
        #
      def get_hashtag_pattern(config = {})
        hashtag_config = config["jekyll-hashtags"]
        case hashtag_config
        when nil, NilClass
          HTML::Pipeline::HashtagFilter::HashtagPattern
        when String
          hashtag_config.to_s
        when Hash
          hashtag_config.fetch("tag_pattern", DEFAULT_HASHTAG_PATTERN)
        else
          raise Class.new(Jekyll::Errors::FatalException),
                "Your jekyll-hashtag config has to either be a" \
            " string or a hash. It's a #{hashtag_config.class} right now."
        end
      end

        # Public: Calculate the base URL to use for hashtag.
        # The custom base URL can be defined in the config as
        # jekyll-hashtag.base_url or jekyll-hashtags, and must
        # be a valid URL (i.e. it must include a protocol and valid domain)
        # It should _not_ have a trailing slash.
        #
        # config - the hash-like configuration of the document's site
        #
        # Returns a URL to use as the base URL for hashtags.
        # Defaults is blank.
        #
      def get_base_url(config = {})
        hashtag_config = config["jekyll-hashtags"]
        case hashtag_config
        when nil, NilClass
          DEFAULT_HASHTAG_BASE_URL
        when String
          hashtag_config.to_s
        when Hash
          hashtag_config.fetch("base_url", DEFAULT_HASHTAG_BASE_URL)
        else
          raise Class.new(Jekyll::Errors::FatalException),
                "Your jekyll-hashtag config has to either be a" \
            " string or a hash. It's a #{hashtag_config.class} right now."
        end
      end

        # Public: Calculate the default tag url to use for hashtag.
        # The custom tag patter can be defined in the config as
        # jekyll-hashtag.tag_url or jekyll-hashtags.
        #
        # config - the hash-like configuration of the document's site
        #
        # Returns a regex valid string to use as the tag pattern for hashtags.
        # Defaults is #{DEFAULT_HASHTAG_URL}
        #
      def get_tag_url(config = {})
        hashtag_config = config["jekyll-hashtags"]
        case hashtag_config
        when nil, NilClass
          DEFAULT_HASHTAG_URL
        when String
          hashtag_config.to_s
        when Hash
          hashtag_config.fetch("tag_url", DEFAULT_HASHTAG_BASE_URL)
        else
          raise Class.new(Jekyll::Errors::FatalException),
                "Your jekyll-hashtag config has to either be a" \
            " string or a hash. It's a #{hashtag_config.class} right now."
        end
      end

      # Public: Defines the conditions for a document to be tagable.
      #
      # doc - the Jekyll::Document or Jekyll::Page
      #
      # Returns true if the doc is written & is HTML.
      def tagable?(doc)
        (doc.is_a?(Jekyll::Page) || doc.write?) &&
            doc.output_ext == ".html" || (doc.permalink&.end_with?("/"))
      end
    end
  end
end

Jekyll::Hooks.register %i[pages documents], :post_render do |doc|
  Jekyll::Hashtags.hashtag_it(doc) if Jekyll::Hashtags.tagable?(doc)
end
