require 'spec_helper'
require 'hashie/mash'
require 'support/shared_contexts/webmock'
require 'rms_api_ruby/chain/http_client'

RSpec.describe RmsApiRuby::Chain::HttpClient do
  include_context 'use webmock'

  let(:url) { 'https://www.example.com' }
  let(:return_method) { :result }
  let(:common_params) { { url: url, return_method: return_method } }

  describe '#initialize' do
    subject { described_class.new hash_params }

    context 'given valid http method' do
      http_methods = %i[get post put patch delete]

      http_methods.each do |method|
        context "http method: :#{method}" do
          let(:hash_params) { common_params.merge(method: method) }
          it { expect(subject).to be_an_instance_of described_class }
        end
      end
    end

    context 'given invalid invalid http method' do
      let(:hash_params) { common_params.merge(method: :unknown) }
      it 'raises an ArgumentError error' do
        msg = "Unsupported http method 'unknown'"
        expect { subject }.to raise_error(ArgumentError, msg)
      end
    end
  end

  describe '#execute_request' do
    let(:client) { described_class.new hash_params }
    subject { client.execute_request }

    context 'sets header' do
      let(:hash_params) { common_params.merge(method: :get, headers: headers) }
      let(:headers) { { foo: :bar, baz: 'foobar' } }
      let(:stub_req) do
        stub_request(:get, url).with(headers: headers)
      end

      it 'requests with correct headers' do
        subject
        expect(stub_req).to have_been_requested
      end
    end

    context 'sets query parameters' do
      let(:hash_params) { common_params.merge(method: :get, params: params) }
      let(:params) { { foo: :bar, baz: 'foobar' } }
      let(:stub_req) do
        stub_request(:get, "#{url}?foo=bar&baz=foobar")
      end

      it 'requests with correct query parameters' do
        subject
        expect(stub_req).to have_been_requested
      end
    end

    context 'sets body' do
      let(:hash_params) { common_params.merge(method: :post, params: params) }
      let(:params) { { foo: :bar, baz: 'foobar' } }
      let(:stub_req) do
        stub_request(:post, url).with(body: 'foo=bar&baz=foobar')
      end

      it 'requests with correct body' do
        subject
        expect(stub_req).to have_been_requested
      end
    end
  end

  describe '#call' do
    subject do
      Flow.new.
        chain(response: :response) do
          described_class.new common_params.merge(method: :get)
        end
    end

    context 'when success' do
      let!(:response_body) do
        {
          fooBar: 'baz',
          foo: {
            BarBaz: 'foobarbaz'
          }
        }
      end
      let!(:stub_req) do
        stub_request(:get, url).to_return(
          status: 200,
          body: response_body.to_xml(root: return_method)
        )
      end

      it { expect(subject.outflow.response).to be_an_instance_of Hashie::Mash }

      it 'transforms keys from camelcase to snakecase' do
        response = subject.outflow.response
        expect(response.foo_bar).to eq 'baz'
      end

      it 'returns nested Hashie::Mash object' do
        nested_attr = subject.outflow.response.foo
        expect(nested_attr).to be_an_instance_of Hashie::Mash
        expect(nested_attr.bar_baz).to eq 'foobarbaz'
      end
    end

    context 'when failure' do
      let!(:stub_req) do
        stub_request(:get, url).to_return(status: 500)
      end

      it { expect(subject.dammed?).to be true }

      it 'stores ServerError into error_pool' do
        flow = subject
        expect(flow.error_pool).to be_an_instance_of RmsApiRuby::ServerError
        expect(flow.error_pool.message).to eq 'HTTP Request failed. Response code: 500'
      end
    end
  end
end
