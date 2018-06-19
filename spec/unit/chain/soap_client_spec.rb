require 'spec_helper'
require 'hashie/mash'
require "savon/mock/spec_helper"

RSpec.describe RmsApiRuby::Chain::SoapClient do
  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  describe '#call' do
    let(:wsdl)          { 'spec/fixtures/wsdl/soap_spec.wsdl' }
    let(:operation)     { :test_operation }
    let(:message)       { 'foobar' }
    let(:return_method) { 'return' }

    subject do
      Flow.new.
        chain(response: :response) do
          described_class.new(wsdl, operation, message, return_method)
        end
    end

    context 'when success' do
      let(:response) { File.read('spec/fixtures/soap_response/success.xml') }

      before do
        savon.expects(:test_operation).with(message: message).returns(response)
      end

      it 'returns an instance of Hashie mash' do
        expect(subject.outflow.response).to be_an_instance_of Hashie::Mash
      end

      it 'returns collect output' do
        response = subject.outflow.response
        expect(response.error_code).to eq 'N00-000'
        expect(response.error_message).to eq 'success'
      end
    end

    context 'when failure' do
      let(:soap_fault) { File.read('spec/fixtures/soap_response/failure.xml') }

      before do
        response = { code: 500, headers: {}, body: soap_fault }
        savon.expects(:test_operation).with(message: message).returns(response)
      end

      it { expect(subject.dammed?).to be true }

      it 'stores ServerError into error_pool' do
        flow = subject
        expect(flow.error_pool).to be_an_instance_of RmsApiRuby::ServerError
        expect(flow.error_pool.message).to eq 'HTTP Request failed. Response code: 500'
      end
    end
  end
end
