require 'spec_helper'
require 'hashie/mash'
require 'support/chain_mock'
require 'support/shared_contexts/logger'

RSpec.describe RmsApiRuby::Item do
  include_context 'shared logger'

  let(:mock_api) { double('Http client mock') }
  let(:args)     { { foo_bar: 'baz' } }
  let(:response) { Hashie::Mash.new(foo: :bar) }

  describe '::get' do
    subject { described_class.get(args) }

    before do
      allow(RmsApiRuby::Item::Get).to receive(:new).
        with(args).
        and_return(mock_api)
      allow(mock_api).to receive(:call).
        and_return(ChainMock.new(key: :response, val: response))
    end

    it 'returns correct object' do
      result = subject
      expect(result.foo).to eq :bar
    end
  end

  describe '::insert' do
    subject { described_class.insert(args) }

    before do
      allow(RmsApiRuby::Item::Insert).to receive(:new).
        with(args).
        and_return(mock_api)
      allow(mock_api).to receive(:call).
        and_return(ChainMock.new(key: :response, val: response))
    end

    it 'returns correct object' do
      result = subject
      expect(result.foo).to eq :bar
    end
  end

  describe 'error handling' do
    subject { described_class.get(args) }

    before do
      allow(RmsApiRuby::Item::Get).to receive(:new).
        and_return(mock_api)
      allow(mock_api).to receive(:call).
        and_return(ChainMock.new(key: :response, val: error, dam: true))
    end

    context 'server error' do
      let(:error)   { RmsApiRuby::ServerError.new(message) }
      let(:message) { 'server error' }
      it 'logs error message' do
        expect(logger_mock).to receive(:error).with(message)
        subject
      end
    end

    context 'other errors' do
      let(:error) { StandardError.new(message) }
      let(:message) { 'standard error' }
      it 'raises an error' do
        expect { subject }.to raise_error StandardError, message
      end
    end
  end
end
