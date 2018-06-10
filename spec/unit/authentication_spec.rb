require 'spec_helper'

RSpec.describe RmsApiRuby::Authentication do
  before do
    allow(RmsApiRuby).to receive_message_chain('configuration.service_secret').
      and_return('foo')
    allow(RmsApiRuby).to receive_message_chain('configuration.license_key').
      and_return('bar')
  end

  describe '::instance' do
    it { expect(described_class.instance).to be_an_instance_of described_class }
  end

  describe '::key' do
    subject { described_class.key }
    it { expect(subject).to eq 'ESA Zm9vOmJhcg==' }
  end
end
