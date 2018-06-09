require 'logger'

module RmsApiRuby
  class << self
    attr_writer :log

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

    def log?
      @log ||= false
    end

    def log(message)
      return unless RmsApiRuby.log?
      configuration.logger.send(configuration.log_level, message)
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
              out_default.respond_to?(:call) ? out_default.call : our_default
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
    option :version,        default: '1.0'
    option :user_name,      default: 'rms_api_ruby'

    # Set a logger for when Restforce.log is set to true, defaulting to STDOUT
    option :logger,         default: ::Logger.new(STDOUT)

    # Set a log level for logging when Restforce.log is set to true, defaulting to :debug
    option :log_level,      default: :debug

    def options
      self.class.options
    end
  end
end
