module RmsApiRuby
  class Orders
    autoload :GetOrder, 'rms_api_ruby/orders/get_order'
    # autoload :ChangeStatus, 'rms_api_ruby/orders/change_status'
    # autoload :GetRequestId, 'rms_api_ruby/orders/get_request_id'
    # autoload :GetResult,    'rms_api_ruby/orders/get_result'

    def self.get_order(**args)
      GetOrder.new(args).execute
    end

    # def change_status
    #  TODO: implement
    # end

    # def get_request_id
    #  TODO: implement
    # end

    # def get_result
    #  TODO: implement
    # end
  end
end
