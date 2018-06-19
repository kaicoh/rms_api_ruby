require 'spec_helper'
require 'support/shared_contexts/logger'

RSpec.describe RmsApiRuby::Chain::Logger do
  include_context 'shared logger'

  describe '#call' do
    it 'sends info and message to the logger' do
      expect(logger_mock).to receive(:info).with('foobar')
      Flow.new.chain { described_class.new(:info, 'foobar') }
    end
  end
end
