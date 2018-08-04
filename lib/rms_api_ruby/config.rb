require 'logger'

module RmsApiRuby
  class << self
    # Returns the current configuration
    #
    # Example
    #
    #   RmsApiRuby.configuration.service_secret = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    #   RmsApiRuby.configuration.license_key    = 'abcdefghijklmnopqrstuvwxyz'
    def configuration
      @configuration ||= Configuration.new
    end

    # Yields the Configuration
    #
    # Example
    #
    # RmsApiRuby.configure do |config|
    #   config.service_secret = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    #   config.license_key    = 'abcdefghijklmnopqrstuvwxyz'
    # end
    def configure
      yield configuration
    end
  end

  class Configuration
    class Option
      attr_reader :configuration, :name, :options

      def self.define(*args)
        new(*args).define
      end

      def initialize(configuration, name, options = {})
        @configuration = configuration
        @name = name
        @options = options
        @default = options.fetch(:default, nil)
      end

      def define
        write_attribute
        define_method if default_provided?
        self
      end

      private

      attr_reader :default
      alias default_provided? default

      def write_attribute
        configuration.send :attr_accessor, name
      end

      def define_method
        our_default = default
        our_name    = name
        configuration.send :define_method, our_name do
          instance_variable_get(:"@#{our_name}") ||
            instance_variable_set(
              :"@#{our_name}",
              our_default.respond_to?(:call) ? our_default.call : our_default
            )
        end
      end
    end

    class << self
      attr_accessor :options

      def option(*args)
        option = Option.define(self, *args)
        (self.options ||= []) << option.name
      end
    end

    option :service_secret, default: -> { ENV['RMS_API_SERVICE_SECRET'] }
    option :license_key,    default: -> { ENV['RMS_API_LICENSE_KEY'] }
    option :shop_url,       default: -> { ENV['RMS_API_SHOP_URL'] }
    option :user_name,      default: 'rms_api_ruby'

    option :logger,         default: ::Logger.new(STDOUT)
    option :log_level,      default: ::Logger::DEBUG

    option :order_api_version,      default: '1.0'
    option :inventory_api_version,  default: '1.0'
    option :item_api_version,       default: '1.0'
    option :product_api_version,    default: '2.0'
    option :navigation_api_version, default: '1.0'
    option :rakuten_pay_order_api_version, default: '2.0'

    def options
      self.class.options
    end
  end
end
