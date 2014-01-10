require 'spec_helper'

describe Users::SessionsController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
    User.delete_all
  end
  it 'allows a valid user to create a session' do
    user = User.create email: 'florian@consulted.co', password: 'tester', password_confirmation: 'tester'
    user.confirm!

    post :create, email: 'florian@consulted.co', password: 'tester'

    expect(response.success?).to be_true
    expect(response.status).to eql 200
  end
end
