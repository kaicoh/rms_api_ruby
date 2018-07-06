require 'rms_api_ruby/navigation/base'

module RmsApiRuby
  class Navigation
    class GenreHeaderGet < RmsApiRuby::Navigation::Base
      private

      def http_method
        :get
      end

      def url
        "#{base_url}genre/header/get"
      end

      def api_name
        'genre header get'
      end
    end
  end
end
