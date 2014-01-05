# encoding: utf-8
require 'spec_helper'

describe User do
  context 'create' do
    subject(:user) { User.new }
    [:name, :email, :telephone].each do |sym|
      it "can be assigned a #{sym}" do
        user.send "#{sym}=", 'test'
        expect(user.send(sym)).to eql 'test'
      end

      it 'can be initialized with a user name' do
        user = User.new sym => 'test'

        expect(user.send(sym)).to eql 'test'
      end
    end

    it 'is created as an unconfirmed user' do
      expect(user.confirmed?).to be_false
    end

    it 'is created as an active user' do
      expect(user.active?).to be_true
    end
  end

  context 'validation' do
    it { should validate_presence_of :name }

    it { should validate_presence_of :email }

    it { should validate_uniqueness_of :email }
  end

  context 'authentication' do
    subject(:user) { User.new }
    it 'should make use of secure password' do
      expect { user.password = 'foo' }.not_to raise_error
    end

    it 'should have a resettable token for single access' do
      expect(user.access_token).not_to be_nil
    end

    it 'should have a reset method for the single access token' do
      user = User.new
      token = user.access_token
      user.generate_new_token!
      expect(user.access_token).not_to equal token
    end
  end
end
