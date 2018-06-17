require 'spec_helper'
require 'savon'
require 'hashie/mash'
require 'rms_api_ruby/soap_api'

class TestClass
  extend RmsApiRuby::SoapApi
end

RSpec.describe RmsApiRuby::SoapApi do
  describe '::handle_error' do
    let(:message) { 'test error' }

    rescueable_errors = [
      RmsApiRuby::ServerError,
      RmsApiRuby::AuthenticationError
    ]

    context 'when rescueable_errors' do
      let(:logger_mock) { double('Logger mock') }

      before do
        allow(RmsApiRuby).to receive_message_chain('configuration.logger').
          and_return(logger_mock)
        allow(logger_mock).to receive(:error)
      end

      rescueable_errors.each do |error|
        it "logged error message of #{error}" do
          expect(logger_mock).to receive(:error).with(message)
          ::TestClass.handle_error error.new(message)
        end
      end
    end

    context 'when another error' do
      it 'raises the error' do
        error = StandardError.new(message)
        expect { ::TestClass.handle_error(error) }.to raise_error error
      end
    end
  end
end
