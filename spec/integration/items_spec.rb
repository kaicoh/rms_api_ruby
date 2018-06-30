require 'spec_helper'
require 'hashie/mash'
require 'support/shared_contexts/config'
require 'support/shared_contexts/logger'
require 'support/shared_contexts/webmock'

RSpec.describe RmsApiRuby::Items do
  include_context 'shared config'
  include_context 'shared logger'
  include_context 'use webmock'

  let(:url) { 'https://api.rms.rakuten.co.jp/es/1.0/items/update' }

  describe '::update' do
    subject { described_class.update(args) }
    let(:args) { { item_url: 'myItem01' } }
    let(:response) do
      {
        status: 'N00',
        itemsUpdateResult: {
          item: 'item001'
        }
      }
    end
    let!(:stub_req) do
      stub_request(:post, url).to_return(
        status: 200,
        body: response.to_xml(root: :result)
      )
    end

    it 'returns a Hashie Mash instance' do
      expect(subject).to be_an_instance_of Hashie::Mash
    end

    it 'returns correct output' do
      response = subject
      expect(response.status).to eq 'N00'
      expect(response.items_update_result.item).to eq 'item001'
    end

    it 'logs the start message' do
      expect(logger_mock).to receive(:info).
        with("RMS ItemsAPI 'UPDATE' started. args: {:item_url=>\"myItem01\"}")
      subject
    end

    it 'logs the complete message' do
      expect(logger_mock).to receive(:info).
        with("RMS ItemsAPI 'UPDATE' completed.")
      subject
    end
  end
end
