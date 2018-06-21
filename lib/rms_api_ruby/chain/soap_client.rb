require 'savon'
require 'hashie/mash'

module RmsApiRuby
  class Chain
    class SoapClient < RmsApiRuby::Chain
      SUCCESS = 200
      FAILURE = 500

      def initialize(wsdl, operation, message, return_method)
        @client        = Savon.client(wsdl: wsdl)
        @operation     = operation
        @message       = message
        @return_method = return_method
      end

      def call
        chain { execute_request }
        when_falsy { status_code == SUCCESS }.
          dam { handle_http_error }
        chain(:response) { parse_to_mash }
      end

      private

      def execute_request
        @response = @client.call(@operation, message: @message)
      rescue Savon::SOAPFault
        @response = Hashie::Mash.new(http: { code: FAILURE })
      end

      def handle_http_error
        message = "HTTP Request failed. Response code: #{status_code}"
        RmsApiRuby::ServerError.new message
      end

      def status_code
        @response.try(:http).try(:code)
      end

      def parse_to_mash
        Hashie::Mash.new(@response.body).
          send("#{@operation}_response").send(@return_method)
      end
    end
  end
end
