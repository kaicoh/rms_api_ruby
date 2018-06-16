require 'rms_api_ruby/soap_api'

module RmsApiRuby
  class Order
    extend RmsApiRuby::SoapApi

    class << self
      def api_methods
        %i[
          get_order
          update_order
          cancel_order
          change_status
          decision_point
          r_bank_account_transfer
          change_r_bank_to_unprocessing
          do_enclosure
          do_un_enclosure
          change_enclosure_parent
          get_enclosure_list
          get_request_id
          get_result
        ]
      end

      def soap_client
        Client
      end
    end

    class Client < RmsApiRuby::SoapApi::Client
      private

      def error_code
        :error_code
      end

      def error_message
        :message
      end

      def message
        auth_params.merge business_params
      end

      def return_method
        :return
      end

      def api_name
        'OrderAPI'
      end

      def wsdl
        "https://api.rms.rakuten.co.jp/es/#{version}/order/ws?WSDL"
      end

      def version
        RmsApiRuby.configuration.order_api_version
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
    end
  end
end
