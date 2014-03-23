require 'spec_helper'

describe AcceptsRequest do
  before(:each) do
    User.delete_all
    Group.delete_all
    setup
  end

  it 'creates an upcoming call from the request' do
    request = User.last.requests.first
    result = AcceptsRequest.for request.id

    expect(result.success?).to be_true

    call = result.fetch :call
    expect(call).to be_a Call
  end

  def setup
    group = Group.create name: 'Test'
    user = User.create valid_params
    user.confirm!
    expert = User.create valid_params.merge email: 'florian1@consulted.co', linkedin_network: 10_000
    expert.confirm!
    expert.offers.create group: group, rate: 20, experience: 5

    RequestsAnExpert.for seeker: User.first, offer: expert.offers.first, start: Time.now, length: 30, message: 'hi!', expert: expert
  end
end
