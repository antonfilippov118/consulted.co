# encoding: utf-8
require 'spec_helper'

describe User do

  it 'has a name' do
    expect do
      User.new name: 'Florian'
    end.not_to raise_error
  end

  [:email].each do |field|
    it { should validate_uniqueness_of field }
  end

  it 'can have a newsletter flag' do
    expect do
      User.new.newsletter = true
    end.not_to raise_error
  end

  context 'being an expert' do
    it 'needs to be confirmed' do
      expect(User.new.can_be_an_expert?).to be_false
    end
  end
end
