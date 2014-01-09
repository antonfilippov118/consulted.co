require 'spec_helper'

describe Users::ConfirmationsController do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  it 'should create a bad request when accessed with nothing' do
    post :create
    expect(response).not_to be_success
  end
end
