require 'spec_helper'

describe Users::ConfirmationsController do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    User.delete_all
  end

  it 'should create a bad request when trying to recreate a token with nothing' do
    post :create
    expect(response).not_to be_success
  end

  it 'should cofirm a user' do
    user = User.create email: 'florian@consulted.co', password: 'tester', password_confirmation: 'tester'
    expect(user.confirmed?).to be_false

    get :show, confirmation_token: user.confirmation_token

    expect(response).to be_success
    expect(User.first.confirmed?).to be_true
    expect(response.status).to eql 200
  end
end
