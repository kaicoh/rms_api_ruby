require 'rms_api_ruby/item/base'

module RmsApiRuby
  class Item
    class Insert < RmsApiRuby::Item::Base
      private

      def http_method
        :post
      end

      def url
        "#{base_url}insert"
      end

      def api_name
        'INSERT'
      end
    end
  end
end
