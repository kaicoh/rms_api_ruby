## ProductAPI

### search

```ruby
args = {
  genre_id: 202513,
  limit: 10,
}

response = RmsApiRuby::Product.search(args)
# => #<Hashie::Mash>

response.keys
# => ["status", "product_search_result"]

response.product_search_result
# => #<Hashie::Mash pagination=#<Hashie::Mash ...>>
```
