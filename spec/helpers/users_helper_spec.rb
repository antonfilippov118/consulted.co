require File.dirname(__FILE__) + '/../spec_helper'

describe UsersHelper do
  before(:each) do
    User.delete_all
  end

  it 'should determine whether someone has enough linkedin contacts' do
    @user = User.create valid_params
    expect(needs_more_contacts?).to be_true

    @user = User.create valid_params.merge linkedin_network: 10_000
    expect(needs_more_contacts?).to be_false
  end

  it 'should determine whether a user is confirmed' do
    @user = User.create valid_params
    expect(needs_confirmation?).to be_true

    @user = User.create valid_params
    @user.confirm!
    expect(needs_confirmation?).to be_false
  end

  it 'should determine whether a user needs to connect to a linkedin account' do
    @user = User.create valid_params
    expect(needs_linkedin?).to be_true

    @user = User.create valid_params
    @user.providers = ['linkedin']
    expect(needs_linkedin?).to be_false
  end

  it 'should determine expert status' do
    @user = User.create valid_params
    expect(possible_expert?).to be_false

    @user = User.create valid_params.merge linkedin_network: 100_000
    @user.confirm!
    expect(possible_expert?).to be_true
  end
end
