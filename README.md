# RmsApiRuby

[![Gem Version](https://badge.fury.io/rb/rms_api_ruby.svg)](https://badge.fury.io/rb/rms_api_ruby)
[![CircleCI](https://circleci.com/gh/Kaicoh/rms_api_ruby/tree/master.svg?style=svg)](https://circleci.com/gh/Kaicoh/rms_api_ruby/tree/master)

RmsApiRuby is a ruby gem for the RMS(Rakuten Marchant Service) Web API. By default all API calls will return [Hashie::Mash](https://github.com/intridea/hashie/tree/v1.2.0) objects.  
At this time this gem supports OrderAPI, InventoryAPI, ItemAPI, ProductAPI and NavigationAPI.

Support
- OrderAPI
- InventoryAPI
- ItemAPI
- ProductAPI
- NavigationAPI

Not Support yet
- CabinetAPI
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
  config.service_secret         = 'Your RMS service secret'
  config.license_key            = 'Your RMS license key'
  config.shop_url               = 'Your RMS shop url'
  config.user_name              = 'user name'              # default 'rms_api_ruby'
  config.order_api_version      = 'Order API version'      # default 1.0
  config.inventory_api_version  = 'Inventory API version'  # default 1.0
  config.item_api_version       = 'Item API version'       # default 1.0
  config.product_api_version    = 'Product API version'    # default 2.0
  config.navigation_api_version = 'Navigation API version' # default 1.0
end
```

### Examples
- [OrderAPI](docs/order_api.md)
- [InventoryAPI](docs/inventory_api.md)
- [ItemAPI](docs/item_api.md)
- [ProductAPI](docs/product_api.md)
- [NavigationAPI](docs/navigation_api.md)

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
