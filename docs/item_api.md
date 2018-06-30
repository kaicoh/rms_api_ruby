## ItemAPI

### get

```ruby
args = { item_url: 'test-item-001' }
response = RmsApiRuby::Item.get(args)
# => #<Hashie::Mash>

response.keys
# => ["status", "item_get_result"]

response.item_get_result
# => #<Hashie::Mash code="N000" item=#<Hashie::Mash ...>>
```

### insert

```ruby
args = {
  item_insert_request: {
    item: {
      item_url: 'test-item-001',
      item_name: 'My Item',
      item_price: 10000,
      genre_id: 999999,
      is_depot: true,
      item_inventory: {
        inventory_type: 1,
        inventories: {
          inventory: {
            inventory_count: 0
          }
        }
      }
    }
  }
}
response = RmsApiRuby::Item.insert(args)
# => #<Hashie::Mash>

response.keys
# => ["status", "item_insert_result"]

response.item_insert_result
# => #<Hashie::Mash code="N000" item=#<Hashie::Mash item_url="test-item-001">>
```

### update

```ruby
args = {
  item_update_request: {
    item: {
      item_url: 'test-item-001',
      item_name: 'My Item2',
    }
  }
}
response = RmsApiRuby::Item.update(args)
# => #<Hashie::Mash>

response.keys
# => ["status", "item_update_result"]

response.item_update_result
# => #<Hashie::Mash code="N000" item=#<Hashie::Mash item_url="test-item-001">>
```

### delete

```ruby
args = {
  item_delete_request: {
    item: {
      item_url: 'test-item-001'
    }
  }
}
response = RmsApiRuby::Item.delete(args)
# => #<Hashie::Mash>

response.keys
# => ["status", "item_delete_result"]

response.item_delete_result
# => #<Hashie::Mash code="N000" item=#<Hashie::Mash item_url="test-item-001">>
```

### search

```ruby
args = { item_url: 'test-item-001' }
response = RmsApiRuby::Item.search(args)
# => #<Hashie::Mash>

response.keys
# => ["status", "item_search_result"]

response.item_search_result
# => #<Hashie::Mash code="200-00" items=#<Hashie::Mash item=#<Hashie::Mash ...>> num_found="1">
```

## ItemsAPI

### update

```ruby
args = {
  items_update_request: {
    items: [
      {
        item_url: 'test-item-001',
        item_name: 'My Item updated',
      },
      {
        item_url: 'test-item-002',
        item_name: 'My Item2 updated',
      }
    ]
  }
}
response = RmsApiRuby::Items.update(args)
# => #<Hashie::Mash >

response.keys
# => ["status", "items_update_result"]

response.items_update_result
# => #<Hashie::Mash item_update_result=#<Hashie::Array [#<Hashie::Mash code="N000" item=#<Hashie::Mash item_url="test-item-001">>, #<Hashie::Mash code="N000" item=#<Hashie::Mash item_url="test-item-002">>]>>
```
