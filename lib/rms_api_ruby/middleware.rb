module RmsApiRuby
  class Middleware
    autoload :RaiseError, 'rms_api_ruby/middleware/raise_error'
    autoload :ParseMash,  'rms_api_ruby/middleware/parse_mash'

    if Faraday::Middleware.respond_to? :register_middleware
      Faraday::Response.register_middleware \
        raise_error: -> { RaiseError },
        parse_mash: -> { ParseMash }
    end
  end
end
