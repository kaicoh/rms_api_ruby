RSpec.shared_context "shared config", shared_context: :metadata do
  let(:auth_params) do
    {
      auth_key: 'test auth key',
      shop_url: 'test shop',
      user_name: 'test user'
    }
  end

  before do
    allow(RmsApiRuby::Authentication).to receive(:key) { 'test auth key' }
    allow(RmsApiRuby).to receive_message_chain('configuration.shop_url').
      and_return('test shop')
    allow(RmsApiRuby).to receive_message_chain('configuration.order_api_version').
      and_return('1.0')
    allow(RmsApiRuby).to receive_message_chain('configuration.inventory_api_version').
      and_return('1.0')
    allow(RmsApiRuby).to receive_message_chain('configuration.item_api_version').
      and_return('1.0')
    allow(RmsApiRuby).to receive_message_chain('configuration.user_name').
      and_return('test user')
  end
end

RSpec.configure do |config|
  config.include_context "shared config", include_shared: true
end
