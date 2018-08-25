require 'spec_helper'
require 'faraday'
require 'support/shared_contexts/config'

RSpec.describe RmsApiRuby::RakutenPayOrder do
  include_context 'shared config'

  describe 'available methods' do
    described_class::API_METHODS.each do |method|
      subject { described_class.respond_to? method }
      it { expect(subject).to be_truthy }
    end
  end

  describe '::connection' do
    subject { described_class.send :connection }
    it { expect(subject).to be_instance_of Faraday::Connection }
  end

  describe '::endpoint' do
    subject { described_class.send :endpoint, 'foo_bar' }
    it { expect(subject).to eq "/es/2.0/order/fooBar/" }
  end
end
