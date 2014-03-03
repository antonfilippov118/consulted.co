require File.dirname(__FILE__) + '/../spec_helper'

describe GroupsController do
  before(:each) do
    request.accept = 'application/json'
  end
  it 'shows the groups as json' do
    Group.delete_all
    Group.create name: 'Finance'
    get :show
    expect(response.success?).to be_true
  end
end
