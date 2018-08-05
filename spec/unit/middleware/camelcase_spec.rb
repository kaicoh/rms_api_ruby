require 'spec_helper'

RSpec.describe RmsApiRuby::Middleware::Camelcase do
  let(:app) { double('app') }
  let(:env) { { body: { foo_bar: 'baz' } } }
  let(:middleware) { described_class.new app }
  subject { middleware.call(env) }

  before do
    allow(app).to receive(:call).with(body: { fooBar: 'baz' })
  end

  it 'turns request body to camelcase' do
    expect { subject }.not_to raise_error
  end
end
