require File.dirname(__FILE__) + '/../../spec_helper'

describe Users::SearchOffersController do

  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
    User.delete_all
  end

  context 'POST #search' do
    context 'for anybody' do
      it 'should fail for anybody' do
        post :search, {}

        expect(response.success?).to be_false
        expect(response.status).to eql(401)
      end

      it 'should fail for an unconfirmed user' do
        user = User.create valid_params

        sign_in user

        post :search, {}

        expect(response.success?).to be_false
        expect(response.status).to eql(422)
      end
    end

  end
end
