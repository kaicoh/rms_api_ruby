require 'spec_helper'
require 'savon'
require 'savon/mock/spec_helper'
require 'hashie/mash'
require 'rms_api_ruby/soap_api/client'

RSpec.describe RmsApiRuby::SoapApi::Client do
  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  let(:operation) { :test_operation }
  let(:args)      { { foo: 'bar' } }

  let(:client) { described_class.new(operation, args) }
  let(:logger_mock) { double('Logger mock') }

  before do
    allow(client).to receive(:error_code) { :error_code }
    allow(client).to receive(:error_message) { :error_message }
    allow(client).to receive(:message).and_return(args)
    allow(client).to receive(:return_method) { :return }
    allow(client).to receive(:api_name) { 'TestAPI' }
    allow(client).to receive(:wsdl) { 'spec/fixtures/wsdl/client.wsdl' }

    allow(logger_mock).to receive(:info)
    allow(logger_mock).to receive(:level=)
    allow(RmsApiRuby).to receive_message_chain('configuration.logger').
      and_return(logger_mock)
    allow(RmsApiRuby).to receive_message_chain('configuration.log_level')

    savon.expects(:test_operation).with(message: args).returns(response)
  end

  describe '#call' do
    subject do
      Flow.new.chain(response: :response) { client }
    end

    context 'request success' do
      let(:response) { File.read('spec/fixtures/soap_response/success.xml') }

      it 'returns an Hashie Mash instance' do
        expect(subject.outflow.response).to be_an_instance_of Hashie::Mash
      end

      it 'returns collect output' do
        response = subject.outflow.response
        expect(response.error_code).to    eq 'N00-000'
        expect(response.error_message).to eq 'success'
      end

      it 'logs the start message' do
        expect(logger_mock).to receive(:info).
          with("RMS TestAPI 'TestOperation' started. args: {:foo=>\"bar\"}")
        subject
      end

      it 'logs the complete message' do
        expect(logger_mock).to receive(:info).
          with("RMS TestAPI 'TestOperation' completed.")
        subject
      end
    end

    context 'request failed' do
      let(:response) { File.read('spec/fixtures/soap_response/auth_error.xml') }
      let(:error_msg) do
        'RMS Api authentication failed. status: E02-001, message: authentication failed'
      end

      it { expect(subject.dammed?).to be true }

      it 'stores AuthenticationError into error_pool' do
        flow = subject
        expect(flow.error_pool).to be_an_instance_of RmsApiRuby::AuthenticationError
        expect(flow.error_pool.message).to eq error_msg
      end
    end
  end
end
