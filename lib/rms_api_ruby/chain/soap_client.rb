require 'savon'

module RmsApiRuby
  class Chain
    class SoapClient < RmsApiRuby::Chain
      SUCCESS = 200

      def initialize(wsdl, operation, message)
        @client    = Savon.client(wsdl: wsdl)
        @operation = operation
        @message   = message
      end

      def call
        chain { @response = @client.call(@operation, message: @message) }
        when_falsy { status_code == SUCCESS }.
          dam { handle_http_error }
        chain(:response) { @response.body["#{@operation}_response".to_sym][:return] }
      end

      private

      def handle_http_error
        message = "HTTP Request failed. Response code: #{status_code}"
        RmsApiRuby::ServerError.new message
      end

      def status_code
        @response.try(:http).try(:code)
      end
    end
  end
end
