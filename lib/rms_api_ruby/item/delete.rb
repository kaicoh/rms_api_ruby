require 'rms_api_ruby/item/base'

module RmsApiRuby
  class Item
    class Delete < RmsApiRuby::Item::Base
      private

      def http_method
        :post
      end

      def url
        "#{base_url}delete"
      end

      def api_name
        'DELETE'
      end
    end
  end
end
