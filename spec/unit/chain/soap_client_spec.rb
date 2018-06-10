require 'spec_helper'

RSpec.describe RmsApiRuby::Chain::SoapClient do
  let(:client_mock)   { double('Savon client mock') }
  let(:response_mock) { double('Soap response mock') }

  before do
    allow(Savon).to receive(:client).and_return(client_mock)
    allow(client_mock).to receive(:call).and_return(response_mock)
  end

  describe '#call' do
    let(:wsdl)      { 'test wsdl' }
    let(:operation) { :test_operation }
    let(:message)   { 'foobar' }

    context 'when success' do
      let(:expected_response) { 'This is the response' }

      before do
        allow(response_mock).to receive_message_chain('http.code').
          and_return(described_class::SUCCESS)
        allow(response_mock).to receive(:body).and_return(
          test_operation_response: {
            return: expected_response
          }
        )
      end

      it 'returns expected response' do
        flow = Flow.new.
          chain(response: :response) { described_class.new(wsdl, operation, message) }
        expect(flow.outflow.response).to eq expected_response
      end
    end

    context 'when failure' do
      before do
        allow(response_mock).to receive_message_chain('http.code').and_return(500)
      end

      it 'dammed' do
        flow = Flow.new.
          chain(response: :response) { described_class.new(wsdl, operation, message) }
        expect(flow.dammed?).to be true
      end

      it 'stores ServerError into error_pool' do
        flow = Flow.new.
          chain(response: :response) { described_class.new(wsdl, operation, message) }
        expect(flow.error_pool).to be_an_instance_of RmsApiRuby::ServerError
        expect(flow.error_pool.message).to eq 'HTTP Request failed. Response code: 500'
      end
    end
  end
end
