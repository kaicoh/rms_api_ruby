require 'rms_api_ruby/utility/hash_keys_underscorable'

module RmsApiRuby
  class Middleware
    class Snakecase < Faraday::Response::Middleware
      include RmsApiRuby::HashKeysUnderscorable

      def on_complete(env)
        env[:body] = snake_keys env[:body]
      end
    end
  end
end
