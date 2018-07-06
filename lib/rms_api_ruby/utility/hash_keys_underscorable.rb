require 'active_support/core_ext'

module RmsApiRuby
  module HashKeysUnderscorable
    def snake_keys(hash)
      return nil if hash.nil?
      hash.each_with_object({}) do |(key, val), acc|
        if val.is_a?(Array)
          val = val.map { |v| to_snake_keys(v) }
        elsif val.is_a?(Hash)
          val = snake_keys(val)
        end
        acc[snake_key(key)] = val
      end
    end

    private

    def snake_key(key)
      if key.is_a?(String)
        key.underscore
      elsif key.is_a?(Symbol)
        key.to_s.underscore.to_sym
      else
        key
      end
    end

    def to_snake_keys(val)
      if val.is_a?(Array)
        val.map { |v| to_snake_keys(v) }
      elsif val.is_a?(Hash)
        snake_keys(val)
      else
        val
      end
    end
  end
end
