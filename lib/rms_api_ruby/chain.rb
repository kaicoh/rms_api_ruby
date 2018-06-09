module RmsApiRuby
  class Chain
    include Waterfall

    autoload :SoapClient,   'rms_api_ruby/chain/soap_client'
    autoload :SoapResponse, 'rms_api_ruby/chain/soap_response'
    autoload :Error,        'rms_api_ruby/chain/error'
    autoload :Logger,       'rms_api_ruby/chain/logger'
  end
end
