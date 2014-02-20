require 'spec_helper'

describe OffersController do
  describe 'GET #show' do
    it 'should respond to showing the offers' do
      get :show

      expect(response.success?).to be_true
    end
  end
end
