require 'spec_helper'
require 'hashie/mash'

RSpec.describe RmsApiRuby::Middleware::ParseMash do
  let(:app) { double('app') }
  let(:env) { { body: { foo_bar: 'baz' } } }
  let(:middleware) { described_class.new app }

  it 'turns response body to Hashie::Mash' do
    middleware.on_complete(env)
    expect(env[:body]).to be_instance_of Hashie::Mash
  end
end
