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

      def api_name
        'InventoryAPI'
      end

      def wsdl
        "https://api.rms.rakuten.co.jp/es/#{version}/inventory/ws?WSDL"
      end

      def version
        RmsApiRuby.configuration.inventory_api_version
      end
    end
  end
end
