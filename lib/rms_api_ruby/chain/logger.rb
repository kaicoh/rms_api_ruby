module RmsApiRuby
  class Chain
    class Logger < RmsApiRuby::Chain
      def initialize(type, message)
        @type         = type
        @message      = message
        @logger       = RmsApiRuby.configuration.logger
        @logger.level = RmsApiRuby.configuration.log_level
      end

      def call
        chain { @logger.send(@type, @message) }
      end
    end
  end
end
