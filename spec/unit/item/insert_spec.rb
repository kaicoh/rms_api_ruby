require 'spec_helper'
require 'support/shared_contexts/config'

RSpec.describe RmsApiRuby::Item::Insert do
  include_context 'shared config'

  let(:object) { described_class.new(foo: :bar) }

  describe '#http_method' do
    subject { object.send(:http_method) }
    it { expect(subject).to eq :post }
  end

  describe '#url' do
    subject { object.send(:url) }
    it { expect(subject).to eq 'https://api.rms.rakuten.co.jp/es/1.0/item/insert' }
  end

  describe '#api_name' do
    subject { object.send(:api_name) }
    it { expect(subject).to eq 'INSERT' }
  end
end
