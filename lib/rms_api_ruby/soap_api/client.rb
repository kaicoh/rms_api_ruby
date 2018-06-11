require 'rms_api_ruby/authentication'
require 'rms_api_ruby/chain'

module RmsApiRuby
  module SoapApi
    class Client
      include Waterfall

      AUTH_ERRORCODE = /^E02-00/

      def initialize(operation, args)
        @operation = operation
        @args = args
      end

      def call
        chain { log :info, start_message }
        chain(response: :response) { execute_request }
        when_truthy { |outflow| outflow.response.error_code =~ AUTH_ERRORCODE }.
          dam { |outflow| auth_error(outflow.response) }
        chain { log :info, complete_message }
      end

      private

      def api_name
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def wsdl
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def version
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def log(level, message)
        RmsApiRuby::Chain::Logger.new(level, message)
      end

      def execute_request
        RmsApiRuby::Chain::SoapClient.new(wsdl, @operation, message)
      end

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

      def auth_error(response)
        refference = "status: #{response.error_code}, message: #{response.message}"
        message    = "RMS Api authentication failed. #{refference}"
        RmsApiRuby::AuthenticationError.new message
      end

      def start_message
        "RMS #{api_name} '#{@operation.to_s.camelize}' started. args: #{@args.inspect}"
      end

      def complete_message
        "RMS #{api_name} '#{@operation.to_s.camelize}' completed."
      end
    end
  end
end
