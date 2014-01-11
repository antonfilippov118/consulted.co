require 'spec_helper'

describe Users::ProfileController do
  before(:each) do
    User.delete_all
    request.env['devise.mapping'] = Devise.mappings[:user]
    user = User.create valid_params
    sign_in user
  end

  it 'shows the users data' do
    get :show

    expect(response.succcess?).to be_true
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
