require 'active_support/core_ext'

module RmsApiRuby
  module HashKeysCamelizable
    def camelize_keys(hash, first_letter = :upper)
      hash.transform_keys { |key| to_camelcase(key, first_letter) }
    end

    private

    def to_camelcase(key, first_letter)
      case key
      when String
        key.camelize(first_letter)
      when Symbol
        key.to_s.camelize(first_letter).to_sym
      else
        key
      end
    end
  end
end
