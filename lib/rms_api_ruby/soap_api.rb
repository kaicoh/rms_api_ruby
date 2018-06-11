module RmsApiRuby
  module SoapApi
    autoload :Client, 'rms_api_ruby/soap_api/client'

    def api_methods
      raise NotImplementedError, "You must implement #{self}::#{__method__}"
    end

    def soap_client
      raise NotImplementedError, "You must implement #{self}::#{__method__}"
    end

    def method_missing(method, *args)
      api_methods.include?(method) ? call_api(method, args.first) : super
    end

    def respond_to_missing?(method, include_private = false)
      api_methods.include?(method) || super
    end

    def call_api(method, args)
      Flow.new.
        chain(response: :response) { soap_client.new(method, args) }.
        on_dam { |error| handle_error(error) }.
        outflow.
        try(:response)
    end

    def handle_error(error)
      raise error
    rescue ServerError, AuthenticationError => e
      RmsApiRuby.configuration.logger.error(e.message)
    end
  end
end
