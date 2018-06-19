require 'spec_helper'
require 'savon'
require 'hashie/mash'
require 'support/shared_contexts/config'

RSpec.describe RmsApiRuby::Order do
  api_methods = %i[
    get_order
    update_order
    cancel_order
    change_status
    decision_point
    r_bank_account_transfer
    change_r_bank_to_unprocessing
    do_enclosure
    do_un_enclosure
    change_enclosure_parent
    get_enclosure_list
    get_request_id
    get_result
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

RSpec.describe RmsApiRuby::Order::Client do
  include_context 'shared config'

  let(:client)    { described_class.new(operation, args) }
  let(:operation) { :test_operation }
  let(:args)      { { foo: 'bar' } }

  describe '#error_code' do
    subject { client.send(:error_code) }
    it { expect(subject).to eq :error_code }
  end

  describe '#error_message' do
    subject { client.send(:error_message) }
    it { expect(subject).to eq :message }
  end

  describe '#message' do
    let(:expected) do
      {
        arg0: auth_params,
        arg1: args
      }
    end
    subject { client.send(:message) }
    it { expect(subject).to eq expected }
  end

  describe '#return_method' do
    subject { client.send(:return_method) }
    it { expect(subject).to eq :return }
  end

  describe '#api_name' do
    subject { client.send(:api_name) }
    it { expect(subject).to eq 'OrderAPI' }
  end

  describe '#wsdl' do
    subject { client.send(:wsdl) }
    it { expect(subject).to eq 'https://api.rms.rakuten.co.jp/es/1.0/order/ws?WSDL' }
  end
end
