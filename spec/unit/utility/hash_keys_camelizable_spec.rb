require 'spec_helper'
require 'rms_api_ruby/utility/hash_keys_camelizable'

class TestClass
  include RmsApiRuby::HashKeysCamelizable
end

RSpec.describe RmsApiRuby::HashKeysCamelizable do
  subject { object.camelize_keys(hash) }
  let(:object) { TestClass.new }

  describe '#camelize_keys' do
    context 'string keys' do
      let(:hash)     { { 'foo_bar' => 'baz' } }
      let(:expected) { { 'FooBar' => 'baz' } }
      it 'transforms to camelized string key hash' do
        expect(subject).to eq expected
      end
    end

    context 'symbol keys' do
      let(:hash)     { { foo_bar: 'baz' } }
      let(:expected) { { FooBar: 'baz' } }
      it 'transforms to camelized symbol key hash' do
        expect(subject).to eq expected
      end
    end

    context 'first letter :lower' do
      subject { object.camelize_keys(hash, :lower) }
      let(:hash)     { { 'foo_bar' => 'baz' } }
      let(:expected) { { 'fooBar' => 'baz' } }
      it 'returns a hash camelized string key except first letter' do
        expect(subject).to eq expected
      end
    end

    context 'when nexted hash' do
      let(:hash) do
        {
          foo_bar: {
            bar_baz: 'foobar'
          }
        }
      end
      let(:expected) do
        {
          FooBar: {
            BarBaz: 'foobar'
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
          foo_bar: [{ bar_baz: 'foo' }, { baz_foo: 'bar' }],
          foo: %w[bar baz]
        }
      end
      let(:expected) do
        {
          FooBar: [{ BarBaz: 'foo' }, { BazFoo: 'bar' }],
          Foo: %w[bar baz]
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
  end
end
