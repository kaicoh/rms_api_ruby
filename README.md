# RmsApiRuby

RmsApiRuby is a ruby gem for the RMS(Rakuten Marchant Service) Web API. By default all API calls will return [Hashie::Mash](https://github.com/intridea/hashie/tree/v1.2.0) objects.  
At this time this gem supports OrderAPI and InventoryAPI only.

Support
- OrderAPI
- InventoryAPI

Not Support yet
- ItemAPI
- ProductAPI
- CabinetAPI
- NavigationAPI
- CategoryAPI
- CouponAPI
- ShopManagimentAPI
- System Event Notification Service
- RakutenPayOrderAPI
- PaymentAPI

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rms_api_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rms_api_ruby

## Usage

### Configuration

You can set the service secret, license key, shop url in environment variables:

```ruby
export RMS_API_SERVICE_SECRET="Your RMS service secret"
export RMS_API_LICENSE_KEY="Your RMS license key"
export RMS_API_SHOP_URL="Your RMS shop url"
```

Or can set any of the options via this way

```ruby
RmsApiRuby.configure do |config|
  config.service_secret        = 'Your RMS service secret'
  config.license_key           = 'Your RMS license key'
  config.shop_url              = 'Your RMS shop url'
  config.user_name             = 'user name'             # default 'rms_api_ruby'
  config.order_api_version     = 'Order API version'     # default 1.0
  config.inventory_api_version = 'Inventory API version' # default 1.0
end
```

### Example

#### OrderAPI

##### GetOrder

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

##### ChangeStatus

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

### InventoryAPI

#### GetInventoryExternal

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Kaicoh/rms_api_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

1. Fork it ( https://github.com/Kaicoh/rms_api_ruby/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
