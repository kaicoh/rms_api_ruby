require 'net/http'
require 'cgi'
require 'uri'
require 'hashie/mash'

module RmsApiRuby
  class Chain
    class HttpClient < RmsApiRuby::Chain
      SERVER_ERROR = 500

      def initialize(method:, url:, headers: nil, params: nil, return_method:)
        @uri = URI.parse url_factory(url, method, params)
        @request = request_class(method).new request_uri(method, @uri)
        @return_method = return_method

        set_headers(headers) if headers.present?
        set_body(params)     if method != :get && params.present?
      end

      def set_headers(headers)
        headers.each { |k, v| @request[k] = v }
      end

      def set_body(params)
        @request.set_form_data params
      end

      def execute_request
        @response = Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: true) do |http|
          http.request @request
        end
      end

      def call
        chain { execute_request }
        when_truthy { status_code >= SERVER_ERROR }.
          dam { handle_http_error }
        chain(:response) { parse_to_mash }
      end

      private

      def url_factory(url, method, params)
        if method == :get && params.present?
          url + '?' + params.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')
        else
          url
        end
      end

      def handle_http_error
        message = "HTTP Request failed. Response code: #{status_code}"
        RmsApiRuby::ServerError.new message
      end

      def status_code
        @response.try(:code).try(:to_i)
      end

      def parse_to_mash
        Hashie::Mash.new(Hash.from_xml(@response.body)).
          send(@return_method)
      end

      def request_class(method)
        case method
        when :get
          ::Net::HTTP::Get
        when :post
          ::Net::HTTP::Post
        when :put
          ::Net::HTTP::Put
        when :patch
          ::Net::HTTP::Patch
        when :delete
          ::Net::HTTP::Delete
        else
          raise ::ArgumentError, "Unsupported http method '#{method}'"
        end
      end

      def request_uri(method, uri)
        method == :get ? uri.request_uri : uri
      end
    end
  end
end
