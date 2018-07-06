module RmsApiRuby
  class Navigation
    autoload :GenreGet,       'rms_api_ruby/navigation/genre_get'
    autoload :GenreTagGet,    'rms_api_ruby/navigation/genre_tag_get'
    autoload :GenreHeaderGet, 'rms_api_ruby/navigation/genre_header_get'

    API_METHODS = %w[
      genre_get
      genre_tag_get
      genre_header_get
    ].freeze

    class << self
      API_METHODS.each do |api_method|
        define_method api_method do |args = nil|
          api_class = "RmsApiRuby::Navigation::#{api_method.camelize}"
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
