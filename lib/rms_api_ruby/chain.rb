module RmsApiRuby
  class Chain
    include Waterfall

    autoload :HttpClient, 'rms_api_ruby/chain/http_client'
    autoload :SoapClient, 'rms_api_ruby/chain/soap_client'
    autoload :Logger,     'rms_api_ruby/chain/logger'
  end
end
