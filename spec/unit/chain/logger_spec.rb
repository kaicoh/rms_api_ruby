require 'spec_helper'

RSpec.describe RmsApiRuby::Chain::Logger do
  let(:logger_mock) { double('Logger mock') }

  before do
    allow(logger_mock).to receive(:info)
    allow(logger_mock).to receive(:level=)
    allow(RmsApiRuby).to receive_message_chain('configuration.logger').
      and_return(logger_mock)
    allow(RmsApiRuby).to receive_message_chain('configuration.log_level')
  end

  describe '#call' do
    it 'sends info and message to the logger' do
      expect(logger_mock).to receive(:info).with('foobar')
      Flow.new.chain { described_class.new(:info, 'foobar') }
    end
  end
end
