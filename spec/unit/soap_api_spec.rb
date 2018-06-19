require 'spec_helper'
require 'savon'
require 'hashie/mash'
require 'rms_api_ruby/soap_api'
require 'support/shared_contexts/logger'

class TestClass
  extend RmsApiRuby::SoapApi
end

RSpec.describe RmsApiRuby::SoapApi do
  include_context 'shared logger'

  describe '::handle_error' do
    let(:message) { 'test error' }

    rescueable_errors = [
      RmsApiRuby::ServerError,
      RmsApiRuby::AuthenticationError
    ]

    context 'when rescueable_errors' do
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
