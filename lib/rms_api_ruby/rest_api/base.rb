require 'rms_api_ruby/chain'
require 'rms_api_ruby/utility/hash_keys_camelizable'

module RmsApiRuby
  class RestApi
    class Base
      include Waterfall
      include RmsApiRuby::HashKeysCamelizable

      def initialize(args, client_class = RmsApiRuby::Chain::HttpClient)
        @args   = args
        @client = client_class.new(
          method: http_method,
          url: url,
          params: form_params(args),
          headers: http_headers,
          return_method: :result
        )
      end

      def call
        chain { log :info, start_message }
        chain(response: :response) { @client.call }
        chain { log :info, complete_message }
      end

      private

      def http_method
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def url
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def start_message
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def complete_message
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def http_headers
        { Authorization: RmsApiRuby::Authentication.key }
      end

      def log(level, message)
        RmsApiRuby::Chain::Logger.new(level, message)
      end

      def form_params(args)
        camelized_params = camelize_keys(args, :lower)
        if http_method == :get
          camelized_params
        elsif camelized_params.nil?
          nil
        else
          camelized_params.to_xml(root: :request, skip_types: true)
        end
      end
    end
  end
end
