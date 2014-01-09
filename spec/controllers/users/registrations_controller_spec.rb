# encoding: utf-8

require 'spec_helper'

describe Users::RegistrationsController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
    User.delete_all
  end
  context '#POST users' do
    it 'gives a unprocessable entity response when accessed without data' do
      post :create
      expect(response.status).to eql 422
      expect(response).not_to be_success
    end

    it 'creates a user when presented with valid data' do
      post :create, valid_params

      expect(response.status).to eql 201
      expect(response).to be_success
      expect(User.count).to eql 1
    end

    it 'does not create a user when params are incorrect' do
      post :create, invalid_params
      expect(response).not_to be_success
      expect(User.count).to eql 0
    end

    it 'should send a confirmation email after registration' do
      post :create, valid_params

      expect(response).to be_success

      expect(ActionMailer::Base.deliveries.last.to.first.downcase).to eql 'florian@consulted.co'
    end
  end

  [:cancel, :new, :edit, :destroy].each do |action|
    it "does not allow #{action}" do
      post action
      expect(response).not_to be_success
      expect(response.status).to eql 405
    end
  end

  def valid_params
    {
      user: {
        name: 'Florian',
        email: 'Florian@consulted.co',
        password: 'password',
        password_confirmation: 'password'
      }
    }
  end

  def invalid_params
    {
      user: {
        name: 'Florian',
        email: 'Florian@consulted.co',
        password: 'fasdfs',
        password_confirmation: 'dsafndsofas'
      }
    }
  end
end
