require 'rms_api_ruby/item/base'

module RmsApiRuby
  class Item
    class Update < RmsApiRuby::Item::Base
      private

      def http_method
        :post
      end

      def url
        "#{base_url}update"
      end

      def api_name
        'UPDATE'
      end
    end
  end
end
