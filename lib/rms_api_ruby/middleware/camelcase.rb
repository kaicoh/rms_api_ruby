require 'active_support'
require 'active_support/core_ext'

module RmsApiRuby
  class Middleware
    class Camelcase < Faraday::Middleware
      def call(env)
        if env[:body].respond_to? :deep_transform_keys!
          env[:body].deep_transform_keys! do |key|
            if key.to_s.first =~ /[A-Z]/
              key.to_s.camelize(:upper).to_sym
            else
              key.to_s.camelize(:lower).to_sym
            end
          end
        end
        @app.call env
      end
    end
  end
end
