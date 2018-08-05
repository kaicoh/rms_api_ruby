require 'spec_helper'
require 'rms_api_ruby/utility/hash_keys_underscorable'

class TestClass
  include RmsApiRuby::HashKeysUnderscorable
end

RSpec.describe RmsApiRuby::HashKeysUnderscorable do
  subject { object.snake_keys(hash) }
  let(:object) { TestClass.new }

  describe '#snake_keys' do
    context 'string keys' do
      let(:hash)     { { 'fooBar' => 'baz' } }
      let(:expected) { { 'foo_bar' => 'baz' } }
      it 'transforms to snakecase string key hash' do
        expect(subject).to eq expected
      end
    end

    context 'symbol keys' do
      let(:hash)     { { fooBar: 'baz' } }
      let(:expected) { { foo_bar: 'baz' } }
      it 'transforms to snakecase symbol key hash' do
        expect(subject).to eq expected
      end
    end

    context 'when nested hash' do
      let(:hash) do
        {
          FooBar: {
            BarBaz: 'foobar'
          }
        }
      end
      let(:expected) do
        {
          foo_bar: {
            bar_baz: 'foobar'
          }
        }
      end
      it 'returns nested camelized key hash' do
        expect(subject).to eq expected
      end
    end

    context 'when hash value is an Array' do
      let(:hash) do
        {
          FooBar: [{ BarBaz: 'foo' }, { BazFoo: 'bar' }],
          foo: %w[bar baz]
        }
      end
      let(:expected) do
        {
          foo_bar: [{ bar_baz: 'foo' }, { baz_foo: 'bar' }],
          foo: %w[bar baz]
        }
      end
      it 'transforms each hash of the Array' do
        expect(subject).to eq expected
      end
    end

    context 'nil' do
      let(:hash) { nil }
      it { expect(subject).to be_nil }
    end

    context 'given object unable to respond :each_with_object' do
      let(:hash) { 'foobar' }
      it 'returns parameter untouched' do
        expect(subject).to eq hash
      end
    end
  end
end
