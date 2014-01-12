require 'spec_helper'

describe Users::SessionsController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
    User.delete_all
  end
  it 'allows a valid user to create a session' do
    user = User.create email: 'florian@consulted.co', password: 'tester', password_confirmation: 'tester'
    user.confirm!

    post :create, user: { email: 'florian@consulted.co', password: 'tester' }

    expect(response.success?).to be_true
    expect(response.status).to eql 200

    expect(response.body).to eql({ success: true }.to_json)
  end

  it 'allows an unconfirmed user to create a session' do
    User.create email: 'florian@consulted.co', password: 'tester', password_confirmation: 'tester'

    post :create, user: { email: 'florian@consulted.co', password: 'tester' }

    expect(response.success?).to be_true
    expect(response.status).to eql 200

    expect(response.body).to eql({ success: true }.to_json)
  end

  it 'does not allow a session for invalid users' do
    post :create, user: { email: 'florian@consulted.co', password: 'tester' }
    expect(response.success?).to be_false
    expect(response.status).to eql 401

    expect(response.body).to eql({ success: false }.to_json)
  end

  it 'allows the user to logout' do
    user = User.create email: 'florian@consulted.co', password: 'tester', password_confirmation: 'tester'
    sign_in user

    expect(controller.current_user).to eql user

    delete :destroy
    expect(controller.current_user).to be_nil
  end
end
