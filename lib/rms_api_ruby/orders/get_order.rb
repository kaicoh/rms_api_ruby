module RmsApiRuby
  module Orders
    module GetOrder
      def get_order(args)
        Flow.new.
          chain  { RmsApiRuby::Orders::Client.new(:get_order, args) }.
          on_dam { |error| RmsApiRuby::Chain::Error.new(error) }.
          outflow
      end
    end
  end
end
