require 'rms_api_ruby/rest_api/base'

module RmsApiRuby
  class Product
    class << self
      def search(args)
        Flow.new.
          chain(response: :response) { Client.new(args).call }.
          on_dam { |error| handle_error(error) }.
          outflow.
          try(:response)
      end

      private

      def handle_error(error)
        raise error
      rescue ServerError, AuthenticationError => e
        RmsApiRuby.configuration.logger.error(e.message)
      end
    end

    class Client < RmsApiRuby::RestApi::Base
      private

      def http_method
        :get
      end

      def url
        "https://api.rms.rakuten.co.jp/es/#{api_version}/product/search"
      end

      def start_message
        "RMS ProductAPI 'SEARCH' started. args: #{@args.inspect}"
      end

      def complete_message
        "RMS ProductAPI 'SEARCH' completed."
      end

      def api_version
        RmsApiRuby.configuration.product_api_version
      end
    end
  end
end
