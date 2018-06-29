require 'rms_api_ruby/item/base'

module RmsApiRuby
  class Item
    class Get < RmsApiRuby::Item::Base
      private

      def http_method
        :get
      end

      def url
        "#{base_url}get"
      end

      def api_name
        'GET'
      end
    end
  end
end
