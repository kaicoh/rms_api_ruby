# RmsApiRuby

RmsApiRuby is a ruby gem for the RMS(Rakuten Marchant Service) Web API. At this time this gem supports OrderAPI only.By default all API calls will return [Hashie::Mash](https://github.com/intridea/hashie/tree/v1.2.0) objects.

Support
- OrderAPI

Not Support yet
- ItemAPI
- ProductAPI
- CabinetAPI
- NavigationAPI
- CategoryAPI
- CouponAPI
- ShopManagimentAPI
- InventoryAPI
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
  config.service_secret = 'Your RMS service secret'
  config.license_key    = 'Your RMS license key'
  config.shop_url       = 'Your RMS shop url'
  config.version        = 'RMS API version' # default 1.0
  config.user_name      = 'user name'       # defaurl 'rms_api_ruby'
end
```

### Example

#### GetOrder

```ruby
args = {
  is_order_number_only_flag: false,
  order_number: ['Rakuten order number you want'],
}
response = RmsApiRuby::Orders.get_order(args)
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
response = RmsApiRuby::Orders.get_request_id
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

response = RmsApiRuby::Orders.change_status(args)
# => #<Hashie::Mash>

response.error_code
# => 'N00-000'

response.message
# => '正常終了'

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Kaicoh/rms_api_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RmsApiRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rms_api_ruby/blob/master/CODE_OF_CONDUCT.md).
