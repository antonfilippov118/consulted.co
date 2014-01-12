require 'spec_helper'

describe Users::OmniauthCallbacksController do
  it 'should be able to post to linkedin' do
    post :linkedin
  end
end
