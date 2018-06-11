require 'rms_api_ruby/order'

module RmsApiRuby
  class Orders < RmsApiRuby::Order
    class << self
      def soap_client
        RmsApiRuby::Order::Client
      end

      def call_api(method, args)
        RmsApiRuby.configuration.logger.warn deprecation_message
        super(method, args)
      end

      def deprecation_message
        "[DEPRECATION]: 'RmsApiRuby::Orders' class is deprecated."\
        " Use 'RmsApiRuby::Order' class instead."
      end
    end
  end
end
