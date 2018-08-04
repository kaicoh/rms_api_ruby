require 'hashie/mash'

module RmsApiRuby
  class Middleware
    class ParseMash < Faraday::Response::Middleware
      def on_complete(env)
        env[:body] = Hashie::Mash.new(env[:body])
      end
    end
  end
end
