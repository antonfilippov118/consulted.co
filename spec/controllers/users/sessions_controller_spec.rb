require 'spec_helper'

describe Users::SessionsController do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
  it 'should be reachable' do
    get :new
    expect(response.success?).to be_true
  end
end
