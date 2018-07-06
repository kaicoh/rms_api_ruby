## NavigationAPI

### genre_get

```ruby
args = { genre_id: 202513 }

response = RmsApiRuby::Navigation.genre_get(args)
# => #<Hashie::Mash>

response.keys
# => ["status", "navigation_genre_get_result"]

response.navigation_genre_get_result
# => #<Hashie::Mash genre=#<Hashie::Mash ...>>
```

### genre_tag_get

```ruby
args = { genre_id: 202513 }

response = RmsApiRuby::Navigation.genre_tag_get(args)
# => #<Hashie::Mash>

response.keys
# => ["status", "navigation_genre_tag_get_result"]

response.navigation_genre_tag_get_result
# => #<Hashie::Mash genre=#<Hashie::Mash ...>>
```

### genre_header_get

```ruby
response = RmsApiRuby::Navigation.genre_header_get
# => #<Hashie::Mash>

response.keys
# => ["status", "navigation_header_get_result"]

response.navigation_header_get_result
# => #<Hashie::Mash genre_last_update_date="2018-05-22T10:00:00+09:00" status="Success" tag_last_update_date="2018-05-22T10:00:00+09:00">
```
