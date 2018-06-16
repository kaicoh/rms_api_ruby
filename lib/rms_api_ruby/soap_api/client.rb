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
        when_truthy { |outflow| authentication_error?(outflow) }.
          dam { |outflow| auth_error(outflow.response) }
        chain { log :info, complete_message }
      end

      private

      def authentication_error?(outflow)
        outflow.response.send(error_code) =~ AUTH_ERRORCODE
      end

      def error_code
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def error_message
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def message
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def return_method
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def api_name
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def wsdl
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def log(level, message)
        RmsApiRuby::Chain::Logger.new(level, message)
      end

      def execute_request
        RmsApiRuby::Chain::SoapClient.new(wsdl, @operation, message, return_method)
      end

      def start_message
        "RMS #{api_name} '#{@operation.to_s.camelize}' started. args: #{@args.inspect}"
      end

      def complete_message
        "RMS #{api_name} '#{@operation.to_s.camelize}' completed."
      end

      def auth_error(response)
        refference = "status: #{response.send(error_code)},"\
          " message: #{response.send(error_message)}"
        message    = "RMS Api authentication failed. #{refference}"
        RmsApiRuby::AuthenticationError.new message
      end
    end
  end
end
