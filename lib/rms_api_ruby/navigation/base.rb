require 'rms_api_ruby/rest_api/base'

module RmsApiRuby
  class Navigation
    class Base < RmsApiRuby::RestApi::Base
      private

      def api_name
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def base_url
        "https://api.rms.rakuten.co.jp/es/#{api_version}/navigation/"
      end

      def api_version
        RmsApiRuby.configuration.navigation_api_version
      end

      def start_message
        "RMS NavigationAPI '#{api_name}' started. args: #{@args.inspect}"
      end

      def complete_message
        "RMS NavigationAPI '#{api_name}' completed."
      end
    end
  end
end
