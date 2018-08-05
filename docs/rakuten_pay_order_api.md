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
