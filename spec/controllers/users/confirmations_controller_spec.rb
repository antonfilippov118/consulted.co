require 'spec_helper'

describe Users::ConfirmationsController do
  it 'should create a bad request when accessed with nothing' do
    post :create
    expect(response).not_to be_success
  end
end
