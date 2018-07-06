require 'spec_helper'
require 'hashie/mash'
require 'support/shared_contexts/config'
require 'support/shared_contexts/logger'
require 'support/shared_contexts/webmock'

RSpec.describe RmsApiRuby::Product do
  include_context 'shared config'
  include_context 'shared logger'
  include_context 'use webmock'

  let(:url) { 'https://api.rms.rakuten.co.jp/es/2.0/product/search' }

  describe '::search' do
    subject { described_class.search(args) }
    let(:args) { { genre_id: 202513 } }
    let(:response) do
      {
        productSearchResult: {
          product: 'product001'
        }
      }
    end
    let!(:stub_req) do
      stub_request(:get, "#{url}?genreId=202513").to_return(
        status: 200,
        body: response.to_xml(root: :result)
      )
    end

    it 'returns a Hashie Mash instance' do
      expect(subject).to be_an_instance_of Hashie::Mash
    end

    it 'returns correct output' do
      response = subject
      expect(response.product_search_result.product).to eq 'product001'
    end

    it 'logs the start message' do
      expect(logger_mock).to receive(:info).
        with("RMS ProductAPI 'SEARCH' started. args: {:genre_id=>202513}")
      subject
    end

    it 'logs the complete message' do
      expect(logger_mock).to receive(:info).
        with("RMS ProductAPI 'SEARCH' completed.")
      subject
    end
  end
end
