require 'spec_helper'
require 'savon'
require 'hashie/mash'
require 'support/shared_contexts/config'

RSpec.describe RmsApiRuby::Inventory do
  api_methods = %i[
    get_inventory_external
    update_inventory_external
    update_single_inventory_external
  ]

  describe '::method missing' do
    let(:args) { 'foobar' }
    before do
      allow(described_class).to receive(:call_api)
    end

    context 'when message is one of the apis' do
      api_methods.each do |method_name|
        it "calls call_api method from #{method_name} method" do
          expect(described_class).to receive(:call_api).with(method_name, 'foobar')
          described_class.send(method_name, args)
        end
      end
    end

    context 'when message is not one of the apis' do
      it 'raise MethodMissing Error' do
        expect { described_class.no_api }.to raise_error NoMethodError
      end
    end
  end

  describe '::respond_to_missing?' do
    context 'when message is one of the apis' do
      api_methods.each do |method_name|
        it "returns true when the message is #{method_name}" do
          expect(described_class.send(:respond_to_missing?, method_name)).to be true
        end
      end
    end

    context 'when message is not one of the apis' do
      it { expect(described_class.send(:respond_to_missing?, :no_api)).to be false }
    end
  end
end

RSpec.describe RmsApiRuby::Inventory::Client do
  include_context 'shared config'

  let(:client)    { described_class.new(operation, args) }
  let(:operation) { :test_operation }
  let(:args)      { { foo: 'bar' } }

  describe '#error_code' do
    subject { client.send(:error_code) }
    it { expect(subject).to eq :err_code }
  end

  describe '#error_message' do
    subject { client.send(:error_message) }
    it { expect(subject).to eq :err_message }
  end

  describe '#message' do
    let(:expected) do
      {
        external_user_auth_model: auth_params,
        updateRequestExternalModel: args
      }
    end
    subject { client.send(:message) }
    it { expect(subject).to eq expected }
  end

  describe '#return_method' do
    subject { client.send(:return_method) }
    it { expect(subject).to eq :result }
  end

  describe '#api_name' do
    subject { client.send(:api_name) }
    it { expect(subject).to eq 'InventoryAPI' }
  end

  describe '#wsdl' do
    let(:expected) do
      RmsApiRuby.root + '/config/wsdl/inventory_v_1.0.wsdl'
    end
    subject { client.send(:wsdl) }
    it { expect(subject).to eq expected }
  end

  describe '#business_params' do
    let(:operation) { :get_inventory_external }
    let(:expected) { { get_request_external_model: args } }
    subject { client.send(:business_params) }
    it { expect(subject).to eq expected }
  end
end
