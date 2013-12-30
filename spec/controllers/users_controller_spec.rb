require 'spec_helper'

describe UsersController do
  describe "POST #user" do
    it "responds with a bad request when accessed without data" do
      post :create
      expect(response).to be_failure
      expect(response.status).to eql 403
    end
  end
end
