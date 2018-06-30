## OrderAPI

### GetOrder

```ruby
args = {
  is_order_number_only_flag: false,
  order_number: ['Rakuten order number you want'],
}
response = RmsApiRuby::Order.get_order(args)
# => #<Hashie::Mash>

response.error_code
# => 'N00-000'

response.message
# => '正常終了'

rakuten_order = response.order_model
# => #<Hashie::Mash>
```

### ChangeStatus

```ruby
response = RmsApiRuby::Order.get_request_id
# => #<Hashie::Mash>

response.error_code
# => 'N00-000'

response.message
# => '正常終了'

request_id = response.request_id
# => 'XXXXXXXXXX'

args = {
  request_id: request_id,
  order_status_model: [
    {
      order_number: ['Rakuten order number you want to change status'],
      status_name: '発送後入金待ち'
    }
  ]
}

response = RmsApiRuby::Order.change_status(args)
# => #<Hashie::Mash>

response.error_code
# => 'N00-000'

response.message
# => '正常終了'

```
