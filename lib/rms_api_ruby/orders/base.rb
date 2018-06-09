require 'rms_api_ruby/authentication'
require 'rms_api_ruby/chain'
require 'rms_api_ruby/config'
require 'rms_api_ruby/orders/response'

module RmsApiRuby
  module Orders
    class Base
      def execute(args)
        Flow.new.
          chain { RmsApiRuby::Chain::SoapClient.new(wsdl, operation, message(args)) }.
          on_dam { |error| RmsApiRuby::Chain::Error.new(error) }
      end

      private

      def operation
        raise ::NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def message(_args)
        auth_params.merge business_params
      end

      def auth_params
        {
          auth_key: RmsApiRuby::Authentication.key,
          shop_url: RmsApiRuby.configuration.shop_url,
          user_name: RmsApiRuby.configuration.user_name
        }
      end

      def business_params
        raise ::NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def wsdl
        "https://api.rms.rakuten.co.jp/es/#{version}/order/ws?WSDL"
      end

      def version
        RmsApiRuby.configuration.version
      end
    end
  end
end
