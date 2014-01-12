require 'spec_helper'

describe Users::OmniauthCallbacksController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  it 'should be able to post to linkedin' do
    post :linkedin
  end
end
