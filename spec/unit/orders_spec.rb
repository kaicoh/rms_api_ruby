require 'spec_helper'
require 'savon'
require 'hashie/mash'

RSpec.describe RmsApiRuby::Orders do
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

  # MEMO: integration test
  # describe '::call_api' do
  # end

  describe '::handle_error' do
    let(:message) { 'test error' }

    rescueable_errors = [
      RmsApiRuby::ServerError,
      RmsApiRuby::AuthenticationError
    ]

    context 'when rescueable_errors' do
      let(:logger_mock) { double('Logger mock') }

      before do
        allow(RmsApiRuby).to  receive(:logger).and_return(logger_mock)
        allow(logger_mock).to receive(:error)
      end

      rescueable_errors.each do |error|
        it "logged error message of #{error}" do
          expect(logger_mock).to receive(:error).with(message)
          described_class.handle_error error.new(message)
        end
      end
    end

    context 'when another error' do
      it 'raises the error' do
        error = StandardError.new(message)
        expect { described_class.handle_error(error) }.to raise_error error
      end
    end
  end
end

RSpec.describe RmsApiRuby::Orders::Client do
  let(:logger_mock)   { double('Logger mock') }
  let(:client_mock)   { double('Soap client mock') }
  let(:response_mock) { double('Soap response mock') }

  let(:operation) { :test_operation }
  let(:args)      { { foo: 'bar' } }

  before do
    allow(RmsApiRuby::Authentication).to receive(:key)

    allow(RmsApiRuby).to receive_message_chain('configuration.shop_url')
    allow(RmsApiRuby).to receive_message_chain('configuration.version')
    allow(RmsApiRuby).to receive_message_chain('configuration.user_name')

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
      Flow.new.chain(response: :response) { described_class.new(operation, args) }
    end

    context 'request success' do
      let(:expected_response) do
        {
          error_code: 'N00-000',
          message: 'success'
        }
      end

      it 'returns an Hashie Mash instance' do
        expect(subject.outflow.response).to be_an_instance_of Hashie::Mash
      end

      it 'returns collect output' do
        response = subject.outflow.response
        expect(response.error_code).to eq 'N00-000'
        expect(response.message).to eq 'success'
      end

      it 'logs the start message' do
        expect(logger_mock).to receive(:info).
          with("RMS OrderAPI 'TestOperation' started. args: {:foo=>\"bar\"}")
        subject
      end

      it 'logs the complete message' do
        expect(logger_mock).to receive(:info).
          with("RMS OrderAPI 'TestOperation' completed.")
        subject
      end
    end

    context 'request failed' do
      let(:expected_response) do
        {
          error_code: 'E02-001',
          message: 'auth error message'
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
