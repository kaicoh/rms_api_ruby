require 'spec_helper'
require 'hashie/mash'

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
      subject do
        Flow.new.
          chain(response: :response) { described_class.new(wsdl, operation, message) }
      end

      let(:expected_response) do
        {
          error_code: 'N00-000',
          message: 'success'
        }
      end

      before do
        allow(response_mock).to receive_message_chain('http.code').
          and_return(described_class::SUCCESS)
        allow(response_mock).to receive(:body).and_return(
          test_operation_response: {
            return: expected_response
          }
        )
      end

      it 'returns an instance of Hashie mash' do
        expect(subject.outflow.response).to be_an_instance_of Hashie::Mash
      end

      it 'returns collect output' do
        response = subject.outflow.response
        expect(response.error_code).to eq 'N00-000'
        expect(response.message).to eq 'success'
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
