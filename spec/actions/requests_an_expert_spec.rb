require 'spec_helper'

describe RequestsAnExpert do
  before(:each) do
    User.delete_all
    Group.delete_all

    setup
  end

  it 'should create a new request for a given expert' do
    user   = User.first
    expert = User.last

    result = RequestsAnExpert.for seeker: user, expert: expert, start: Time.now, length: 30, offer: expert.offers.first, message: ''
    expect(result.success?).to be_true

    request = expert.calls.first

    expect(request).to be_a Call
  end

  it 'should send a confirmation mail to the expert' do
    user   = User.first
    expert = User.last

    RequestsAnExpert.for seeker: user, expert: expert, start: Time.now, length: 30, offer: expert.offers.first, message: ''

    mails = ActionMailer::Base.deliveries
    expect(mails.last).not_to be_nil
  end

  def setup
    group = Group.create name: 'Test'
    user = User.create valid_params
    user.confirm!
    expert = User.create valid_params.merge email: 'florian1@consulted.co', linkedin_network: 10_000
    expert.availabilities.create starts: Time.now, ends: Time.now + 5.hours
    expert.confirm!
    expert.offers.create group: group, rate: 20, experience: 5
  end
end
