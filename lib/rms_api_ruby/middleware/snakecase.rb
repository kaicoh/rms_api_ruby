require 'active_support'
require 'active_support/core_ext'

module RmsApiRuby
  class Middleware
    class Snakecase < Faraday::Response::Middleware
      def on_complete(env)
        # rubocop:disable Style/GuardClause
        if env[:body].respond_to? :deep_transform_keys!
          env[:body].deep_transform_keys! { |key| key.to_s.underscore.to_sym }
        end
        # rubocop:enable Style/GuardClause
      end
    end
  end
end
