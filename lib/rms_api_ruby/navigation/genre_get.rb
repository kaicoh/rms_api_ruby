require 'rms_api_ruby/navigation/base'

module RmsApiRuby
  class Navigation
    class GenreGet < RmsApiRuby::Navigation::Base
      private

      def http_method
        :get
      end

      def url
        "#{base_url}genre/get"
      end

      def api_name
        'genre get'
      end
    end
  end
end
