require 'spec_helper'
require 'hashie/mash'
require 'support/shared_contexts/config'
require 'support/shared_contexts/webmock'

RSpec.describe RmsApiRuby::RakutenPayOrder do
  include_context 'shared config'
  include_context 'use webmock'

  let(:url) { 'https://api.rms.rakuten.co.jp/es/2.0/order' }

  describe '::get_order' do
    subject { described_class.get_order(args) }
    let(:args) { { order_number_list: ['0000-1111-2222'] } }
    let(:response) do
      {
        MessageModelList: %w[foobar barbaz bazfoo],
        OrderModelList: %w[foo bar baz]
      }
    end
    let!(:stub_req) do
      stub_request(:post, "#{url}/getOrder/").to_return(
        status: 200,
        headers: { 'Content-Type' => 'application/json;charset=utf-8' },
        body: response.to_json
      )
    end

    it 'returns a Hashie Mash instance' do
      expect(subject).to be_an_instance_of Hashie::Mash
    end

    it 'returns correct output' do
      response = subject
      expect(response.message_model_list).to eq %w[foobar barbaz bazfoo]
      expect(response.order_model_list).to eq %w[foo bar baz]
    end
  end
end
