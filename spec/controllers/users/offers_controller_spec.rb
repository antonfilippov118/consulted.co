require File.dirname(__FILE__) + '/../../spec_helper'

describe Users::OffersController do
  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
    User.delete_all
  end

  describe 'updating offers' do
    it 'should assign offers to a user' do
      user = User.create valid_params
      user.confirm!
      sign_in user
      put :update, {}

      expect(response.success?).to be_true
      expect(response.status).to eql 200
    end

    it 'should not assign offers to a user when not confirmed' do
      user = User.create valid_params
      sign_in user
      put :update, {}

      expect(response.success?).to be_false
      expect(response.status).to eql 422
    end

    it 'should not assign any offers to a user when the user is not logged in' do
      put :update, {}
      expect(response.success?).to be_false
      expect(response.status).to eql(401)
    end
  end

  def valid_params
    {
      email: 'florian@consulted.co',
      name: 'Florian',
      password: 'tester',
      password_confirmation: 'tester',
      confirmation_sent_at: Time.now
    }
  end
end
