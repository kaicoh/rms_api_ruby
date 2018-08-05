require 'spec_helper'

RSpec.describe RmsApiRuby::Middleware::Snakecase do
  let(:app) { double('app') }
  let(:env) { { body: { fooBar: 'baz' } } }
  let(:middleware) { described_class.new app }

  it 'turns response body to Hashie::Mash' do
    middleware.on_complete(env)
    expect(env[:body]).to eq(foo_bar: 'baz')
  end
end
