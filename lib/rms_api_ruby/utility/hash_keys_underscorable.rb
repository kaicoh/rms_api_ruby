require 'active_support/core_ext'

module RmsApiRuby
  module HashKeysUnderscorable
    def snake_keys(hash)
      hash.each_with_object({}) do |(key, val), acc|
        if val.is_a?(Array)
          val = val.map { |v| snake_keys(v) }
        elsif val.is_a?(Hash)
          val = snake_keys(val)
        end
        acc[to_snakecase(key)] = val
      end
    end

    private

    def to_snakecase(key)
      if key.is_a?(String)
        key.underscore
      elsif key.is_a?(Symbol)
        key.to_s.underscore.to_sym
      else
        key
      end
    end
  end
end
