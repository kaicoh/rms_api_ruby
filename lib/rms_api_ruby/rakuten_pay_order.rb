require 'rms_api_ruby/middleware'

module RmsApiRuby
  class RakutenPayOrder
    BASE_URL = 'https://api.rms.rakuten.co.jp'.freeze
    API_METHODS = %w[
      get_order
      search_order
      confirm_order
      update_order_shipping
      update_order_delivery
      update_order_orderer
      update_order_remarks
      update_order_sender
      update_order_memo
      get_payment
      cancel_order
      get_sub_status_list
      update_order_sub_status
    ].freeze

    class << self
      API_METHODS.each do |api_method|
        define_method api_method do |args = nil|
          conn.post do |req|
            req.url endpoint(api_method)
            req.headers['Content-Type'] = 'application/json; charset=utf-8'
            req.headers['Authorization'] = RmsApiRuby::Authentication.key
            req.body = args
          end
        end
      end

      private

      def conn
        Faraday.new(url: BASE_URL) do |faraday|
          faraday.request  :camelcase
          faraday.request  :url_encoded
          faraday.request  :json

          faraday.response :logger
          faraday.response :parse_mash
          faraday.response :snakecase
          faraday.response :xml,  content_type: /\bxml$/
          faraday.response :json, content_type: /\bjson$/

          faraday.use :instrumentation
          faraday.adapter Faraday.default_adapter
        end
      end

      def endpoint(api_method)
        "/es/#{RmsApiRuby.configuration.rakuten_pay_order_api_version}" \
        "/order/#{api_method.to_s.camelize(:lower)}/"
      end
    end
  end
end
