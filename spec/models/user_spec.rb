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
    before(:all) do
      User.delete_all
    end
    it 'should not be an expert right away' do
      expect(User.new.can_be_an_expert?).to be_false
    end

    it 'needs to have at least 1 network contact in Linkedin' do
      user = User.create name: 'Florian', password: 'tester', password_confirmation: 'tester', linkedin_network: 1, confirmation_sent_at: Time.now
      user.confirm!
      expect(user.can_be_an_expert?).to be_true
    end

    it 'should be confirmed' do
      user = User.create name: 'Florian', password: 'tester', password_confirmation: 'tester', linkedin_network: 1
      expect(user.can_be_an_expert?).to be_false
    end
  end
end
