require 'spec_helper'

describe Users::ProfileController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
    User.delete_all
  end

  it 'shows the users data when user is logged in' do
    user = User.create valid_params
    user.confirm!
    sign_in user

    get :profile

    expect(response.success?).to be_true
    expect(response.status).to eql 200
  end

  it 'does not show the users data when signed out' do
    get :profile

    expect(response.success?).to be_false
    expect(response.status).to eql 401
  end

  it 'marks unconfirmed users with a flag' do
    user = User.create valid_params
    sign_in user

    get :profile

    expect(response.success?).to be_true
    json_hash = JSON.parse response.body

    expect(json_hash).to have_key 'confirmed'
    expect(json_hash['confirmend']).to be_false
  end

  def valid_params
    {
      email: 'florian@consulted.co',
      name: 'Florian',
      password: 'tester',
      password_confirmation: 'tester'
    }
  end
end