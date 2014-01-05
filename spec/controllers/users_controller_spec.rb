# encoding: utf-8

require 'spec_helper'

describe UsersController do
  describe 'POST #user' do
    let :valid_params do
      {
        name: 'Florian',
        email: 'Florian@consulted.co',
        password: 'tester',
        password_confirmation: 'tester'
      }
    end

    let :invalid_params do
      {
        name: 'Florian',
        email: 'Florian@consulted.co',
        password_confirmation: 'tester'
      }
    end

    let(:user_class) { User }

    before(:each) do
      user_class.delete_all
    end

    it 'responds with a bad request when accessed without data' do
      post :create
      expect(response).not_to be_success
      expect(response.status).to eql 400
    end

    it 'creates a user when accessed with valid data' do
      post :create, valid_params
      expect(response).to be_success
      expect(response.status).to eql 201

      expect(user_class.count).to eql 1
    end

    it 'sends an email for user confirmation after creation' do
      post :create, valid_params
      expect(ActionMailer::Base.deliveries.last.to).to eql [valid_params[:email]]
      expect(ActionMailer::Base.deliveries.last.subject).to eql 'Your consulted.co profile activation'
    end
  end

  describe 'GET #user' do
    it 'returns "Forbidden" when user has no valid token' do
      get :show
      expect(response.status).to eql 403
      expect(response).not_to be_success
    end
  end
end
