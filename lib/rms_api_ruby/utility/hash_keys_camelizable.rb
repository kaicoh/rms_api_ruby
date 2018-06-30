require 'active_support/core_ext'

module RmsApiRuby
  module HashKeysCamelizable
    def camelize_keys(hash, first_letter = :upper)
      hash.each_with_object({}) do |(key, val), acc|
        if val.is_a?(Array)
          val = val.map { |v| to_camel_keys(v, first_letter) }
        elsif val.is_a?(Hash)
          val = camelize_keys(val, first_letter)
        end
        acc[camel_key(key, first_letter)] = val
      end
    end

    private

    def camel_key(key, first_letter)
      if key.is_a?(String)
        key.camelize(first_letter)
      elsif key.is_a?(Symbol)
        key.to_s.camelize(first_letter).to_sym
      else
        key
      end
    end

    def to_camel_keys(val, first_letter)
      if val.is_a?(Array)
        val.map { |v| to_camel_keys(v, first_letter) }
      elsif val.is_a?(Hash)
        camelize_keys(val, first_letter)
      else
        val
      end
    end
  end
end
