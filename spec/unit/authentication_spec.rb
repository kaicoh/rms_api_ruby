require 'spec_helper'

RSpec.describe RmsApiRuby::Authentication do
  before do
    RmsApiRuby.configure do |config|
      config.service_secret = 'foo'
      config.license_key    = 'bar'
    end
  end

  describe '::instance' do
    it { expect(described_class.instance).to be_an_instance_of described_class }
  end

  describe '::key' do
    subject { described_class.key }
    it { expect(subject).to eq 'ESA Zm9vOmJhcg==' }
  end
end
