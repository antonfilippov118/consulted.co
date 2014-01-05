# encoding: utf-8

require 'spec_helper'

describe AuthenticatesUser do

  before(:each) do
    user_class.delete_all
  end

  it 'passes a user who gave correct data' do
    User.create email: 'Florian@consulted.co', password: 'tester', password_confirmation: 'tester', name: 'Florian'
    data = {
      email: 'Florian@consulted.co',
      password: 'tester'
    }

    result = AuthenticatesUser.check data
    expect(result.success?).to be_true
  end

  it 'fails when a user does not exist' do
    data = {
      email: 'florian@consulted.co',
      password: 'tester'
    }

    result = AuthenticatesUser.check data

    expect(result.success?).to be_false
  end

  it 'finds the user by email regardless of case ' do
    User.create email: 'fLoriAn@conSulted.co', password: 'tester', password_confirmation: 'tester', name: 'Florian'
    data = {
      email: 'Florian@consulted.co',
      password: 'tester'
    }

    result = AuthenticatesUser.check data
    expect(result.success?).to be_true
  end

  it 'fails when a user does not give the right password' do
    User.create email: 'Florian@consulted.co', password: 'tester', password_confirmation: 'tester', name: 'Florian'
    data = {
      email: 'Florian@consulted.co',
      password: 'foo'
    }

    result = AuthenticatesUser.check data

    expect(result.success?).to be_false
  end

  def user_class
    User
  end
end
