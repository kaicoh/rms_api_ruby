require 'active_support'
require 'active_support/core_ext'
require 'waterfall'
require "rms_api_ruby/version"
require 'rms_api_ruby/config'

module RmsApiRuby
  Error               = Class.new(StandardError)
  ServerError         = Class.new(Error)
  AuthenticationError = Class.new(Error)

  autoload :Authentication, 'rms_api_ruby/authentication'
  autoload :Chain,          'rms_api_ruby/chain'
  autoload :Order,          'rms_api_ruby/order'
  autoload :Orders,         'rms_api_ruby/orders'
  autoload :Inventory,      'rms_api_ruby/inventory'
end
