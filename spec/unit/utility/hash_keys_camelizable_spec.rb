require 'spec_helper'
require 'rms_api_ruby/utility/hash_keys_camelizable'

class TestClass
  include RmsApiRuby::HashKeysCamelizable
end

RSpec.describe RmsApiRuby::HashKeysCamelizable do
  let(:object) { TestClass.new }

  describe '#camelize_keys' do
    context 'first letter :upper' do
      subject { object.camelize_keys(hash, :upper) }

      context 'key is a string' do
        let(:hash)     { { 'foo_bar' => 'baz' } }
        let(:expected) { { 'FooBar' => 'baz' } }
        it 'returns a hash camelized string key' do
          expect(subject).to eq expected
        end
      end

      context 'key is a symbol' do
        let(:hash)     { { foo_bar: 'baz' } }
        let(:expected) { { FooBar: 'baz' } }
        it 'returns a hash camelized symbol key' do
          expect(subject).to eq expected
        end
      end
    end

    context 'first letter :lower' do
      subject { object.camelize_keys(hash, :lower) }

      context 'key is a string' do
        let(:hash)     { { 'foo_bar' => 'baz' } }
        let(:expected) { { 'fooBar' => 'baz' } }
        it 'returns a hash camelized string key' do
          expect(subject).to eq expected
        end
      end

      context 'key is a symbol' do
        let(:hash)     { { foo_bar: 'baz' } }
        let(:expected) { { fooBar: 'baz' } }
        it 'returns a hash camelized symbol key' do
          expect(subject).to eq expected
        end
      end
    end
  end
end
