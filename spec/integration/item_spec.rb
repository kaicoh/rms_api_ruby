require 'spec_helper'
require 'hashie/mash'
require 'support/shared_contexts/config'
require 'support/shared_contexts/logger'
require 'support/shared_contexts/webmock'

RSpec.describe RmsApiRuby::Item do
  include_context 'shared config'
  include_context 'shared logger'
  include_context 'use webmock'

  let(:url) { 'https://api.rms.rakuten.co.jp/es/1.0/item' }

  describe '::get' do
    subject { described_class.get(args) }
    let(:args) { { item_url: 'myItem01' } }
    let(:response) do
      {
        status: 'N00',
        itemGetResult: {
          itemUrl: 'myItem01',
          itemName: 'item001'
        }
      }
    end
    let!(:stub_req) do
      stub_request(:get, "#{url}/get?itemUrl=myItem01").to_return(
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
      expect(response.item_get_result.item_url).to  eq 'myItem01'
      expect(response.item_get_result.item_name).to eq 'item001'
    end

    it 'logs the start message' do
      expect(logger_mock).to receive(:info).
        with("RMS ItemAPI 'GET' started. args: {:item_url=>\"myItem01\"}")
      subject
    end

    it 'logs the complete message' do
      expect(logger_mock).to receive(:info).
        with("RMS ItemAPI 'GET' completed.")
      subject
    end
  end

  describe '::insert' do
    subject { described_class.insert(args) }
    let(:args) { { item_url: 'myItem01' } }
    let(:response) do
      {
        status: 'N00',
        itemInsertResult: {
          code: 'N000',
          item: 'item001'
        }
      }
    end
    let!(:stub_req) do
      stub_request(:post, "#{url}/insert").to_return(
        status: 201,
        body: response.to_xml(root: :result)
      )
    end

    it 'returns a Hashie Mash instance' do
      expect(subject).to be_an_instance_of Hashie::Mash
    end

    it 'returns correct output' do
      response = subject
      expect(response.status).to eq 'N00'
      expect(response.item_insert_result.code).to eq 'N000'
      expect(response.item_insert_result.item).to eq 'item001'
    end

    it 'logs the start message' do
      expect(logger_mock).to receive(:info).
        with("RMS ItemAPI 'INSERT' started. args: {:item_url=>\"myItem01\"}")
      subject
    end

    it 'logs the complete message' do
      expect(logger_mock).to receive(:info).
        with("RMS ItemAPI 'INSERT' completed.")
      subject
    end
  end

  describe '::update' do
    it 'updates the item'
  end

  describe '::delete' do
    it 'deletes the item'
  end

  describe '::search' do
    it 'returns items satisfiying the conditions'
  end
end
