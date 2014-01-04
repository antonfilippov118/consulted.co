# encoding: utf-8
require 'spec_helper'

describe User do
  subject(:user) { User.new }
  context 'create' do
    [:name, :email, :telephone, :single_access_token].each do |sym|
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
    it 'should make use of secure password' do
      expect { user.password = 'foo' }.not_to raise_error
    end

    it 'should have a resettable token for single access' do
      expect(user.single_access_token).not_to be_nil
    end
  end
end
