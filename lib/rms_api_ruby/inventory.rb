require 'rms_api_ruby/soap_api'

module RmsApiRuby
  class Inventory
    extend RmsApiRuby::SoapApi

    class << self
      def api_methods
        %i[
          get_inventory_external
          update_inventory_external
          update_single_inventory_external
        ]
      end

      def soap_client
        Client
      end
    end

    class Client < RmsApiRuby::SoapApi::Client
      private

      def error_code
        :err_code
      end

      def error_message
        :err_message
      end

      def message
        auth_params.merge business_params
      end

      def return_method
        :result
      end

      def api_name
        'InventoryAPI'
      end

      def wsdl
        File.join(RmsApiRuby.root, 'config', 'wsdl', "inventory_v_#{version}.wsdl")
      end

      def version
        RmsApiRuby.configuration.inventory_api_version
      end

      def auth_params
        {
          external_user_auth_model: {
            auth_key: RmsApiRuby::Authentication.key,
            shop_url: RmsApiRuby.configuration.shop_url,
            user_name: RmsApiRuby.configuration.user_name
          }
        }
      end

      def business_params
        key = if @operation == :get_inventory_external
                :get_request_external_model
              else
                :updateRequestExternalModel
              end
        { key => @args }
      end
    end
  end
end
