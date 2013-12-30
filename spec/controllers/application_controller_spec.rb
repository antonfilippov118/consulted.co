require "spec_helper"

describe ApplicationController do
  controller do
    def index
      render nothing: true
    end
  end

  describe "handling AccessDenied exceptions" do
    it "redirects to the /401.html page" do
      get :index
      expect(response).to be_success
    end
  end
end
