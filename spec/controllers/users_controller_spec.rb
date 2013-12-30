require 'spec_helper'

describe UsersController do
  describe "POST #user" do
    it "responds with a bad request when accessed without data" do
      post :create
      expect(response).not_to be_success
      expect(response.status).to eql 400
    end
  end
end
