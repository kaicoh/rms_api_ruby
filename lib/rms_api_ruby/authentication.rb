require 'singleton'
require 'base64'

module RmsApiRuby
  class Authentication
    include Singleton

    attr_reader :key

    def initialize
      @key = "ESA #{Base64.strict_encode64(service_secret + ':' + license_key)}"
    end

    def self.key
      instance.key
    end

    private

    def service_secret
      RmsApiRuby.configuration.service_secret
    end

    def license_key
      RmsApiRuby.configuration.license_key
    end
  end
end
