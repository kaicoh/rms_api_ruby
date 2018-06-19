require 'spec_helper'
require 'savon'
require 'savon/mock/spec_helper'
require 'hashie/mash'

require 'support/shared_contexts/config'
require 'support/shared_contexts/logger'

RSpec.describe RmsApiRuby::Inventory do
  include Savon::SpecHelper

  include_context 'shared config'
  include_context 'shared logger'

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  describe '::get_inventory_external' do
    subject { RmsApiRuby::Inventory.get_inventory_external(args) }

    let(:args) { { foo: 'bar' } }
    let(:expected_message) do
      {
        external_user_auth_model: auth_params,
        get_request_external_model: args
      }
    end

    context 'valid request' do
      before do
        response = File.read('spec/fixtures/soap_response/get_inventory_external.xml')
        savon.expects(:get_inventory_external).with(message: expected_message).
          returns(response)
      end

      it 'returns an Hashie Mash instance' do
        expect(subject).to be_an_instance_of Hashie::Mash
      end

      it 'returns collect output' do
        response = subject
        expect(response.err_code).to    eq 'N00-000'
        expect(response.err_message).to eq 'success'
      end

      it 'logs the start message' do
        expect(logger_mock).to receive(:info).
          with("RMS InventoryAPI 'GetInventoryExternal' started. args: {:foo=>\"bar\"}")
        subject
      end

      it 'logs the complete message' do
        expect(logger_mock).to receive(:info).
          with("RMS InventoryAPI 'GetInventoryExternal' completed.")
        subject
      end
    end

    context 'invalid request' do
      before do
        response = File.read('spec/fixtures/soap_response/failure.xml')
        savon.expects(:get_inventory_external).with(message: expected_message).
          returns(response)
      end

      it 'logs the error information' do
        msg = 'HTTP Request failed. Response code: 500'
        expect(logger_mock).to receive(:error).with(msg)
        subject
      end
    end
  end
end
