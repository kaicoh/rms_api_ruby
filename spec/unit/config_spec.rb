require 'spec_helper'

RSpec.describe RmsApiRuby do
  before do
    ENV['RMS_API_SERVICE_SECRET'] = nil
    ENV['RMS_API_LICENSE_KEY']    = nil
    ENV['RMS_API_SHOP_URL']       = nil
  end

  after do
    RmsApiRuby.instance_variable_set :@configuration, nil
  end

  describe '#configuration' do
    subject { RmsApiRuby.configuration }

    it { expect(subject).to be_an_instance_of RmsApiRuby::Configuration }

    context 'by_default' do
      it { expect(subject.order_api_version).to eq '1.0' }
      it { expect(subject.inventory_api_version).to eq '1.0' }
      it { expect(subject.item_api_version).to eq '1.0' }
      it { expect(subject.product_api_version).to eq '2.0' }
      it { expect(subject.user_name).to eq 'rms_api_ruby' }
      it { expect(subject.logger).to be_an_instance_of ::Logger }
      it { expect(subject.log_level).to eq ::Logger::DEBUG }
    end

    context 'when environment variables are defined' do
      before do
        {
          'RMS_API_SERVICE_SECRET' => 'foo',
          'RMS_API_LICENSE_KEY'    => 'bar',
          'RMS_API_SHOP_URL'       => 'baz'
        }.each do |key, value|
          allow(ENV).to receive(:[]).with(key).and_return(value)
        end
      end

      it { expect(subject.service_secret).to eq 'foo' }
      it { expect(subject.license_key).to    eq 'bar' }
      it { expect(subject.shop_url).to       eq 'baz' }
    end
  end

  describe '#configure' do
    %i[
      service_secret
      license_key
      shop_url
      order_api_version
      inventory_api_version
      user_name
      logger
      log_level
    ].each do |attr|
      it "allows #{attr} to be set" do
        RmsApiRuby.configure do |config|
          config.send("#{attr}=", 'foobar')
        end
        expect(RmsApiRuby.configuration.send(attr)).to eq 'foobar'
      end
    end
  end
end
