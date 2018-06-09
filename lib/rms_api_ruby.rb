require 'waterfall'
require "rms_api_ruby/version"
require 'rms_api_ruby/config'

module RmsApiRuby
  autoload :Authentication, 'rms_api_ruby/authentication'
  autoload :Orders,         'rms_api_ruby/orders'

  Error               = Class.new(StandardError)
  ServerError         = Class.new(Error)
  AuthenticationError = Class.new(Error)
  UnauthorizedError   = Class.new(Error)
end
