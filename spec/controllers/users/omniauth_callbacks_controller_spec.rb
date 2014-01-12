require 'spec_helper'

describe Users::OmniauthCallbacksController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:linkedin]
  end

  # TODO: find out how to test this properly

end
