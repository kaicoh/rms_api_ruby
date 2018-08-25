## RakutenPayOrderAPI

### GetOrder

```ruby
args = {
  order_number_list: ['Rakuten order number you want'],
}

response = RmsApiRuby::RakutenPayOrder.get_order(args)
# => #<Hashie::Mash>

response.keys
# => ["message_model_list", "order_model_list"]

response.order_model_list
# => #<Hashie::Array>
```

### getSubStatusList

```ruby
response = RmsApiRuby::RakutenPayOrder.get_sub_status_list
# => #<Hashie::Mash>

response.keys
# => ["message_model_list", "status_model_list"]

response.status_model_list
# => #<Hashie::Array>
```

### updateOrderSubStatus

```ruby
args = {
  sub_status_id: ['one of the ids got from getSubStatusList API']
  order_number_list: ['Rakuten order number you want'],
}

response = RmsApiRuby::RakutenPayOrder.update_order_sub_status(args)
# => #<Hashie::Mash>

response.keys
# => ["message_model_list"]

response.message_model_list
# => #<Hashie::Array>
```

### updateOrderShipping

NOTE: Attribute of model list like 'Basketid_model_list' and 'Shipping_model_list' starts uppercase.

```ruby
args = {
  order_number: 'Rakuten order number you want',
  Basketid_model_list: [
    {
      basket_id: 'basketId of PackageModel got from GetOrder API',
      Shipping_model_list: [
        {
          shipping_detail_id: 'shippingDetailId of ShippingModel got from GetOrder API',
          delivery_company: 'choose delivery company code from official reference page',
          shipping_number: 'delivery number of ledgersheet',
          shipping_date: 'YYYY-MM-DD',
          shipping_delete_flag: '0(not delete) or 1(delete)',
        }
      ],
    }
  ]
}

response = RmsApiRuby::RakutenPayOrder.update_order_shipping(args)
# => #<Hashie::Mash>

response.keys
# => ["message_model_list"]

response.order_model_list
# => #<Hashie::Array>
```
