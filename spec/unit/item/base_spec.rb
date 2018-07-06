require 'spec_helper'
require 'support/shared_contexts/config'
require 'rms_api_ruby/item/base'

RSpec.describe RmsApiRuby::Item::Base do
  include_context 'shared config'

  let(:mock_client_class) { double('Http client class mock') }
  let(:mock_client) { double('Http client mock') }
  let(:args)        { { foo_bar: 'baz' } }

  before do
    allow(mock_client_class).to receive(:new).
      and_return(mock_client)
    allow_any_instance_of(described_class).to receive(:http_method).
      and_return(:http_method)
    allow_any_instance_of(described_class).to receive(:url).
      and_return('https://example.com')
    allow_any_instance_of(described_class).to receive(:api_name).
      and_return('TEST')
  end

  describe '#base_url' do
    subject { described_class.new(args, mock_client_class).send(:base_url) }
    it { expect(subject).to eq 'https://api.rms.rakuten.co.jp/es/1.0/item/' }
  end

  describe '#start_message' do
    subject { described_class.new(args, mock_client_class).send(:start_message) }
    it { expect(subject).to eq "RMS ItemAPI 'TEST' started. args: {:foo_bar=>\"baz\"}" }
  end

  describe '#complete_message' do
    subject { described_class.new(args, mock_client_class).send(:complete_message) }
    it { expect(subject).to eq "RMS ItemAPI 'TEST' completed." }
  end
end
