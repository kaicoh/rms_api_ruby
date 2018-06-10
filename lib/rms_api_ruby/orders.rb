require 'rms_api_ruby/authentication'
require 'rms_api_ruby/chain'
require 'rms_api_ruby/config'

module RmsApiRuby
  class Orders
    class << self
      API_METHODS = %i[
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
      ].freeze

      def method_missing(method, *args)
        API_METHODS.include?(method) ? call_api(method, args.first) : super
      end

      def respond_to_missing?(method, include_private = false)
        API_METHODS.include?(method) || super
      end

      def call_api(type, args)
        Flow.new.
          chain(response: :response) { Client.new(type, args) }.
          on_dam { |error| handle_error(error) }.
          outflow.
          try(:response)
      end

      def handle_error(error)
        raise error
      rescue ServerError, AuthenticationError => e
        RmsApiRuby.logger.error(e.message)
      end
    end

    class Client
      include Waterfall

      AUTH_ERRORCODE = /^E02-00/

      def initialize(operation, args)
        @operation = operation
        @args = args
      end

      def call # rubocop:disable Metrics/AbcSize
        chain { RmsApiRuby::Chain::Logger.new(:info, start_message) }
        chain(:response) { RmsApiRuby::Chain::SoapClient.new(wsdl, @operation, message) }
        when_truthy { |outflow| outflow.response[:error_code] =~ AUTH_ERRORCODE }.
          dam { |outflow| auth_error(outflow.response) }
        chain { RmsApiRuby::Chain::Logger.new(:info, complete_message) }
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

      def auth_error(response)
        refference = "status: #{response[:error_code]}, message: #{response[:message]}"
        message    = "RMS Api authentication failed. #{refference}"
        RmsApiRuby::AuthenticationError.new message
      end

      def start_message
        "RMS OrderAPI '#{@operation.to_s.camelize}' started. args: #{args.inspect}"
      end

      def complete_message
        "RMS OrderAPI '#{@operation.to_s.camelize}' completed."
      end
    end
  end
end
