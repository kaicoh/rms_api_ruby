require 'spec_helper'
require 'hashie/mash'

require 'support/shared_contexts/config'
require 'support/shared_contexts/logger'

RSpec.describe RmsApiRuby::Item do
  describe '::get' do
    it 'returns the item'
  end

  describe '::insert' do
    it 'creates an item'
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
