require 'spec_helper'
require 'savon'
require 'savon/mock/spec_helper'
require 'hashie/mash'

require 'support/shared_contexts/config'
require 'support/shared_contexts/logger'

RSpec.describe RmsApiRuby::Order do
  include Savon::SpecHelper

  include_context 'shared config'
  include_context 'shared logger'

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  before do
    allow_any_instance_of(RmsApiRuby::Order::Client).to receive(:wsdl).
      and_return('spec/fixtures/wsdl/order.wsdl')
  end

  describe '::get_order' do
    subject { RmsApiRuby::Order.get_order(args) }

    let(:args) { { foo: 'bar' } }
    let(:expected_message) { { arg0: auth_params, arg1: args } }

    context 'valid request' do
      before do
        response = File.read('spec/fixtures/soap_response/get_order.xml')
        savon.expects(:get_order).with(message: expected_message).returns(response)
      end

      it 'returns an Hashie Mash instance' do
        expect(subject).to be_an_instance_of Hashie::Mash
      end

      it 'returns correct output' do
        response = subject
        expect(response.error_code).to eq 'N00-000'
        expect(response.message).to    eq 'success'
      end

      it 'logs the start message' do
        expect(logger_mock).to receive(:info).
          with("RMS OrderAPI 'GetOrder' started. args: {:foo=>\"bar\"}")
        subject
      end

      it 'logs the complete message' do
        expect(logger_mock).to receive(:info).
          with("RMS OrderAPI 'GetOrder' completed.")
        subject
      end
    end

    context 'invalid request' do
      before do
        response = File.read('spec/fixtures/soap_response/get_order_auth_error.xml')
        savon.expects(:get_order).with(message: expected_message).returns(response)
      end

      it 'logs the error information' do
        msg = 'RMS Api authentication failed. status: E02-001, '\
          'message: authentication failed'
        expect(logger_mock).to receive(:error).with(msg)
        subject
      end
    end
  end
end
