require 'rms_api_ruby/rest_api/base'

module RmsApiRuby
  class Item
    class Base < RmsApiRuby::RestApi::Base
      private

      def api_name
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def base_url
        "https://api.rms.rakuten.co.jp/es/#{api_version}/item/"
      end

      def api_version
        RmsApiRuby.configuration.item_api_version
      end

      def start_message
        "RMS ItemAPI '#{api_name}' started. args: #{@args.inspect}"
      end

      def complete_message
        "RMS ItemAPI '#{api_name}' completed."
      end
    end
  end
end
