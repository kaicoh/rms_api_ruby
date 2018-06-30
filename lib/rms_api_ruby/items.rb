require 'rms_api_ruby/item/base'

module RmsApiRuby
  class Items
    class << self
      def update(args)
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

    class Client < RmsApiRuby::Item::Base
      private

      def http_method
        :post
      end

      def url
        "https://api.rms.rakuten.co.jp/es/#{api_version}/items/update"
      end

      def start_message
        "RMS ItemsAPI 'UPDATE' started. args: #{@args.inspect}"
      end

      def complete_message
        "RMS ItemsAPI 'UPDATE' completed."
      end
    end
  end
end
