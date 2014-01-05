# encoding: utf-8

require 'spec_helper'

describe AuthenticatesUser do

  before(:each) do
    user_class.delete_all
  end

  it 'passes a user who gave correct data' do
    create_user

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
    create_user email: 'fLoriAn@conSulted.co'
    data = {
      email: 'Florian@consulted.co',
      password: 'tester'
    }

    result = AuthenticatesUser.check data
    expect(result.success?).to be_true
  end

  it 'fails when a user does not give the right password' do
    create_user
    data = {
      email: 'Florian@consulted.co',
      password: 'foo'
    }

    result = AuthenticatesUser.check data

    expect(result.success?).to be_false
  end

  it 'fails when a user is not confirmed' do
    create_user confirmed: false
    data = {
      email: 'Florian@consulted.co',
      password: 'tester'
    }

    result = AuthenticatesUser.check data

    expect(result.success?).to be_false
  end

  def user_class
    User
  end

  def create_user(opts = {})
    params = {
      email: 'Florian@consulted.co',
      password: 'tester',
      password_confirmation: 'tester',
      name: 'Florian',
      confirmed: true
    }.merge opts

    User.create params
  end
end
