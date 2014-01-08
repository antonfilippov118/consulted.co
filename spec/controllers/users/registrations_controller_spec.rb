# encoding: utf-8

require 'spec_helper'

describe Users::RegistrationsController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  context '#POST users' do
    it 'gives a bad request response when accessed without data' do
      post :create
      expect(response.status).to eql 400
      expect(response).not_to be_success
    end

    it 'creates a user when presented with valid data' do
      post :create, valid_params

      expect(response.status).to eql 201
      expect(response).to be_success
      expect(User.count).to eql 1
    end
  end

  def valid_params
    {
      name: 'Florian',
      email: 'Florian@consulted.co',
      password: 'password',
      password_confirmation: 'password'
    }
  end
end
