require 'spec_helper'
require 'savon'
require 'hashie/mash'
require 'rms_api_ruby/soap_api/client'

RSpec.describe RmsApiRuby::SoapApi::Client do
  let(:logger_mock)   { double('Logger mock') }
  let(:client_mock)   { double('Soap client mock') }
  let(:response_mock) { double('Soap response mock') }

  let(:operation) { :test_operation }
  let(:args)      { { foo: 'bar' } }

  let(:client) { described_class.new(operation, args) }

  before do
    allow(client).to receive(:error_code) { :error_code }
    allow(client).to receive(:error_message) { :error_message }
    allow(client).to receive(:message).and_return(args)
    allow(client).to receive(:return_method) { :return }
    allow(client).to receive(:api_name) { 'TestAPI' }
    allow(client).to receive(:wsdl) { 'test wsdl' }

    allow(Savon).to receive(:client).and_return(client_mock)
    allow(client_mock).to receive(:call).and_return(response_mock)
    allow(response_mock).to receive_message_chain('http.code').
      and_return(RmsApiRuby::Chain::SoapClient::SUCCESS)

    allow(logger_mock).to receive(:info)
    allow(logger_mock).to receive(:level=)
    allow(RmsApiRuby).to receive_message_chain('configuration.logger').
      and_return(logger_mock)
    allow(RmsApiRuby).to receive_message_chain('configuration.log_level')

    allow(response_mock).to receive(:body).and_return(
      test_operation_response: {
        return: expected_response
      }
    )
  end

  describe '#call' do
    subject do
      Flow.new.chain(response: :response) { client }
    end

    context 'request success' do
      let(:expected_response) do
        {
          error_code: 'N00-000',
          error_message: 'success'
        }
      end

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
      let(:expected_response) do
        {
          error_code: 'E02-001',
          error_message: 'auth error message'
        }
      end
      let(:error_msg) do
        'RMS Api authentication failed. status: E02-001, message: auth error message'
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
