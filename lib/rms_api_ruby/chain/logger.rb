module RmsApiRuby
  class Chain
    class Logger < RmsApiRuby::Chain
      def initialize(type, message)
        @type    = type
        @message = message
      end

      def call
        chain { logger.send(@type, @message) }
      end

      private

      def logger
        RmsApiRuby.configuration.logger
      end
    end
  end
end
