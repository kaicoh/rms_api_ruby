require 'rms_api_ruby/chain/http_client'
require 'rms_api_ruby/chain'
require 'rms_api_ruby/utility/hash_keys_camelizable'

module RmsApiRuby
  class Item
    class Base
      include Waterfall
      include RmsApiRuby::HashKeysCamelizable

      def initialize(args)
        @args   = args
        @client = RmsApiRuby::Chain::HttpClient.new(
          method: http_method,
          url: url,
          params: camelize_keys(args, :lower),
          headers: http_headers,
          return_method: :result
        )
      end

      def call
        chain { log :info, start_message }
        chain(response: :response) { @client.call }
        chain { log :info, complete_message }
      end

      private

      def http_method
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def url
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def api_name
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def base_url
        "https://api.rms.rakuten.co.jp/es/#{api_version}/item/"
      end

      def api_version
        RmsApiRuby.configuration.item_api_version
      end

      def http_headers
        { Authorization: RmsApiRuby::Authentication.key }
      end

      def log(level, message)
        RmsApiRuby::Chain::Logger.new(level, message)
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
