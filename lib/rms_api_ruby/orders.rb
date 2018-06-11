require 'rms_api_ruby/soap_api'

module RmsApiRuby
  class Orders
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

      def api_name
        'OrderAPI'
      end

      def wsdl
        "https://api.rms.rakuten.co.jp/es/#{version}/order/ws?WSDL"
      end

      def version
        RmsApiRuby.configuration.order_api_version
      end
    end
  end
end
