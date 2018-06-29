module RmsApiRuby
  class Item
    autoload :Get,    'rms_api_ruby/item/get'
    autoload :Insert, 'rms_api_ruby/item/insert'
    autoload :Update, 'rms_api_ruby/item/update'
    autoload :Delete, 'rms_api_ruby/item/delete'

    API_METHODS = %w[
      get
      insert
      update
      delete
    ].freeze

    class << self
      API_METHODS.each do |api_method|
        define_method api_method do |args = nil|
          api_class = "RmsApiRuby::Item::#{api_method.camelize}"
          call_api api_class.constantize.new(args)
        end
      end

      private

      def call_api(api)
        Flow.new.
          chain(response: :response) { api.call }.
          on_dam { |error| handle_error(error) }.
          outflow.
          try(:response)
      end

      def handle_error(error)
        raise error
      rescue ServerError, AuthenticationError => e
        RmsApiRuby.configuration.logger.error(e.message)
      end
    end
  end
end
