## InventoryAPI

### GetInventoryExternal

```ruby
args = {
  inventory_search_range: 100
}
response = RmsApiRuby::Inventory.get_inventory_external(args)
# => #<Hashie::Mash>

response.keys
# => ["err_code", "err_message", "get_response_external_item", "@xmlns:n1", "@xmlns:n2", "@xsi:type"]

response.err_code
# => 'N00-000'

response.err_message
# => '正常終了'

response.get_response_external_item
# => #<Hashie::Mash>
```
