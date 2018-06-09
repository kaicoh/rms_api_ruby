require 'rms_api_ruby/authentication'
require 'rms_api_ruby/chain'
require 'rms_api_ruby/config'

module RmsApiRuby
  class Orders
    class Client
      include Waterfall

      def initialize(operation, args)
        @operation = operation
        @args = args
      end

      def call
        chain { RmsApiRuby::Chain::SoapClient.new(wsdl, @operation, message) }
      end

      private

      def message
        auth_params.merge business_params
      end

      def auth_params
        {
          arg0: {
            auth_key: RmsApiRuby::Authentication.key,
            shop_url: RmsApiRuby.configuration.shop_url,
            user_name: RmsApiRuby.configuration.user_name
          }
        }
      end

      def business_params
        { arg1: @args }
      end

      def wsdl
        "https://api.rms.rakuten.co.jp/es/#{version}/order/ws?WSDL"
      end

      def version
        RmsApiRuby.configuration.version
      end
    end

    autoload :GetOrder, 'rms_api_ruby/orders/get_order'
    # autoload :ChangeStatus, 'rms_api_ruby/orders/change_status'
    # autoload :GetRequestId, 'rms_api_ruby/orders/get_request_id'
    # autoload :GetResult,    'rms_api_ruby/orders/get_result'

    extend GetOrder
    # extend ChangeStatus
    # extend GetRequestId
    # extend GetResult
  end
end
