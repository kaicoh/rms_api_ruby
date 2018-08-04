module RmsApiRuby
  class Middleware
    autoload :Camelcase, 'rms_api_ruby/middleware/camelcase'
    autoload :Snakecase, 'rms_api_ruby/middleware/snakecase'
    autoload :ParseMash, 'rms_api_ruby/middleware/parse_mash'

    if Faraday::Middleware.respond_to? :register_middleware
      Faraday::Request.register_middleware \
        camelcase: -> { Camelcase }

      Faraday::Response.register_middleware \
        snakecase: -> { Snakecase },
        parse_mash: -> { ParseMash }
    end
  end
end
