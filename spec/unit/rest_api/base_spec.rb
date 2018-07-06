require 'spec_helper'
require 'hashie/mash'
require 'support/chain_mock'
require 'support/shared_contexts/config'
require 'support/shared_contexts/logger'
require 'rms_api_ruby/rest_api/base'

RSpec.describe RmsApiRuby::RestApi::Base do
  include_context 'shared config'
  include_context 'shared logger'

  let(:mock_client) { double('Http client mock') }
  let(:args)        { { foo_bar: 'baz' } }
  let(:response)    { Hashie::Mash.new(foo: :bar) }

  before do
    allow_any_instance_of(described_class).to receive(:http_method).
      and_return(:http_method)
    allow_any_instance_of(described_class).to receive(:url).
      and_return('https://example.com')
  end

  describe '#initialize' do
    let(:mock_client_class) { double('Http client class mock') }

    subject { described_class.new(args, mock_client_class) }

    it 'initializes a client with correct params' do
      expect(mock_client_class).to receive(:new).
        with(
          method: :http_method,
          url: 'https://example.com',
          params: { fooBar: 'baz' }.to_xml(root: :request),
          headers: { Authorization: 'test auth key' },
          return_method: :result
        )
      subject
    end
  end

  describe '#call' do
    let(:mock_client_class) { double('Http client class mock') }

    subject do
      Flow.new.chain(response: :response) { described_class.new(args, mock_client_class) }
    end

    before do
      allow(mock_client_class).to receive(:new).
        and_return(mock_client)
      allow(mock_client).to receive(:call).
        and_return(ChainMock.new(key: :response, val: response))
      allow_any_instance_of(described_class).to receive(:start_message).
        and_return('This is a start message')
      allow_any_instance_of(described_class).to receive(:complete_message).
        and_return('This is a complete message')
    end

    it 'calls the client call method' do
      expect(mock_client).to receive(:call)
      subject
    end

    it 'logs the start message' do
      expect(logger_mock).to receive(:info).with('This is a start message')
      subject
    end

    it 'logs the complete message' do
      expect(logger_mock).to receive(:info).with('This is a complete message')
      subject
    end
  end
end
