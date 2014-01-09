require 'spec_helper'

describe Users::UtilitiesController do
  before(:each) do
    User.delete_all
  end
  context 'GET avalailable' do
    it 'shows if an email is taken' do
      User.create email: 'florian@consulted', password: 'tester', password_confirmation: 'tester'

      get :available, email: 'florian@consulted'

      expect(response).not_to be_success
      expect(response.body).to eql({ available: false }.to_json)
    end

    it 'shows if an email is available' do
      User.create email: 'florian@consulted', password: 'tester', password_confirmation: 'tester'

      get :available, email: 'sebastian@consulted'

      expect(response).to be_success
      expect(response.body).to eql({ available: true }.to_json)
    end
  end
end
