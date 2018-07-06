require 'spec_helper'
require 'hashie/mash'
require 'support/shared_contexts/config'
require 'support/shared_contexts/logger'
require 'support/shared_contexts/webmock'

RSpec.describe RmsApiRuby::Navigation do
  include_context 'shared config'
  include_context 'shared logger'
  include_context 'use webmock'

  let(:url) { 'https://api.rms.rakuten.co.jp/es/1.0/navigation' }

  describe '::genre_get' do
    subject { described_class.genre_get(args) }
    let(:args) { { genre_id: 202513 } }
    let(:response) do
      {
        navigationGenreGetResult: {
          genre: 'genre001'
        }
      }
    end
    let!(:stub_req) do
      stub_request(:get, "#{url}/genre/get?genreId=202513").to_return(
        status: 200,
        body: response.to_xml(root: :result)
      )
    end

    it 'returns a Hashie Mash instance' do
      expect(subject).to be_an_instance_of Hashie::Mash
    end

    it 'returns correct output' do
      response = subject
      expect(response.navigation_genre_get_result.genre).to eq 'genre001'
    end

    it 'logs the start message' do
      expect(logger_mock).to receive(:info).
        with("RMS NavigationAPI 'genre get' started. args: {:genre_id=>202513}")
      subject
    end

    it 'logs the complete message' do
      expect(logger_mock).to receive(:info).
        with("RMS NavigationAPI 'genre get' completed.")
      subject
    end
  end

  describe '::genre_tag_get' do
    subject { described_class.genre_tag_get(args) }
    let(:args) { { genre_id: 202513 } }
    let(:response) do
      {
        navigationGenreTagGetResult: {
          genre: 'genre001'
        }
      }
    end
    let!(:stub_req) do
      stub_request(:get, "#{url}/genre/tag/get?genreId=202513").to_return(
        status: 200,
        body: response.to_xml(root: :result)
      )
    end

    it 'returns a Hashie Mash instance' do
      expect(subject).to be_an_instance_of Hashie::Mash
    end

    it 'returns correct output' do
      response = subject
      expect(response.navigation_genre_tag_get_result.genre).to eq 'genre001'
    end

    it 'logs the start message' do
      expect(logger_mock).to receive(:info).
        with("RMS NavigationAPI 'genre tag get' started. args: {:genre_id=>202513}")
      subject
    end

    it 'logs the complete message' do
      expect(logger_mock).to receive(:info).
        with("RMS NavigationAPI 'genre tag get' completed.")
      subject
    end
  end

  describe '::genre_header_get' do
    subject { described_class.genre_header_get }
    let(:response) do
      {
        navigationGenreHeaderGetResult: {
          genre: 'genre001'
        }
      }
    end
    let!(:stub_req) do
      stub_request(:get, "#{url}/genre/header/get").to_return(
        status: 200,
        body: response.to_xml(root: :result)
      )
    end

    it 'returns a Hashie Mash instance' do
      expect(subject).to be_an_instance_of Hashie::Mash
    end

    it 'returns correct output' do
      response = subject
      expect(response.navigation_genre_header_get_result.genre).to eq 'genre001'
    end

    it 'logs the start message' do
      expect(logger_mock).to receive(:info).
        with("RMS NavigationAPI 'genre header get' started. args: nil")
      subject
    end

    it 'logs the complete message' do
      expect(logger_mock).to receive(:info).
        with("RMS NavigationAPI 'genre header get' completed.")
      subject
    end
  end
end
