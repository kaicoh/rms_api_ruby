require 'rms_api_ruby/item/base'

module RmsApiRuby
  class Item
    class Search < RmsApiRuby::Item::Base
      private

      def http_method
        :get
      end

      def url
        "#{base_url}search"
      end

      def api_name
        'SEARCH'
      end
    end
  end
end
