# encoding: utf-8

require 'spec_helper'

describe AuthenticatesUser do

  before(:each) do
    user_class.delete_all
  end

  it 'passes a user who gave correct data' do
    create_user

    result = AuthenticatesUser.check data
    expect(result.success?).to be_true
  end

  it 'fails when a user does not exist' do
    result = AuthenticatesUser.check data
    expect(result.success?).to be_false
  end

  it 'finds the user by email regardless of case ' do
    create_user email: 'fLoriAn@conSulted.co'

    result = AuthenticatesUser.check data
    expect(result.success?).to be_true
  end

  it 'fails when a user does not give the right password' do
    create_user
    result = AuthenticatesUser.check data(password: 'foo')

    expect(result.success?).to be_false
  end

  it 'fails when a user is not confirmed' do
    create_user confirmed: false

    result = AuthenticatesUser.check data

    expect(result.success?).to be_false
  end

  it 'fails when a user is not active' do
    create_user active: false

    result = AuthenticatesUser.check data

    expect(result.success?).to be_false
  end

  def data(opts = {})
    {
      email: 'Florian@consulted.co',
      password: 'tester'
    }.merge opts
  end
end
