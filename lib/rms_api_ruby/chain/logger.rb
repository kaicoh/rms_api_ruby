module RmsApiRuby
  module Chain
    class Logger < RmsApiRuby::Chain
      def initialize(type, message)
        @type    = type
        @message = message
      end

      def call
        chain { RmsApiRuby.logger.send(@type, @message) }
      end
    end
  end
end
