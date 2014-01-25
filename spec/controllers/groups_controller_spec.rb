require File.dirname(__FILE__) + '/../spec_helper'

describe GroupsController do
  it 'responds with category data' do
    get :show
    expect(response).to be_success
    expect(response.status).to eql 200
  end
end
