require 'spec_helper'

describe RequestsAnExpert do
  before(:each) do
    User.delete_all
    Group.delete_all
  end

  it 'should create a new request for a given expert' do
    group = Group.create name: 'Test'

    user = User.create valid_params
    user.confirm!

    expert = User.create valid_params.merge email: 'florian1@consulted.co', linkedin_network: 10_000

    expert.availabilities.create starts: Time.now, ends: Time.now + 5.hours
    expert.confirm!

    expert.offers.create group: group, rate: 20, experience: 5

    result = RequestsAnExpert.for user: user, expert: expert, start: Time.now, length: 30, offer: expert.offers.first
    expect(result.success?).to be_true

    request = expert.requests.first

    expect(request).to be_a User::Request
  end
end
