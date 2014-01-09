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

  it 'should confirm a user' do
    token = create_new_user_and_send_email

    get :show, confirmation_token: token

    expect(response).to be_success
    expect(User.first.confirmed?).to be_true
    expect(response.status).to eql 200
  end

  it 'should not confirm a user with an invalid token' do
    create_new_user_and_send_email
    get :show, confirmation_token: 'foo'

    expect(response).not_to be_success
    expect(response.status).to eql 400
  end

  def create_new_user_and_send_email
    User.create email: 'florian@consulted.co', password: 'tester', password_confirmation: 'tester', confirmation_sent_at: 1.day.ago, unconfirmed_email: 'florian@consulted.co'

    # fetch the token from the email just sent
    body = ActionMailer::Base.deliveries.last.body.encoded

    match = body.scan(/\?confirmation\_token=.*\"/).first
    match.gsub('?confirmation_token=', '').gsub('"', '')
  end
end
