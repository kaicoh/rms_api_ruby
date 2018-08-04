require 'rms_api_ruby/utility/hash_keys_camelizable'

module RmsApiRuby
  class Middleware
    class Camelcase < Faraday::Middleware
      include RmsApiRuby::HashKeysCamelizable

      def call(env)
        env[:body] = camelize_keys(env[:body], :lower)
        @app.call env
      end
    end
  end
end
