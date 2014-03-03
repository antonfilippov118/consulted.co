require File.dirname(__FILE__) + '/../spec_helper'

describe FindsAvailableExperts do
  before(:each) do
    Group.delete_all
    User.delete_all
  end

  it 'looks up experts for any given group' do
    group = Group.create name: 'Finance'

    user = User.create valid_params
    user.confirm!

    expert = User.create valid_params.merge linkedin_network: 10_000, languages: %w(english mandarin)
    expert.confirm!

    expert.availabilities.create starts: Time.now - 2.hours, ends: Time.now + 2.hours
    expert.offers.create rate: 25, experience: 2, lengths: %w(30 60), group: group

    result = FindsAvailableExperts.for group
    expect(result.success?).to be_true
    expect(result[:experts].length).to eql 1
    expect(result[:experts].first).to eql expert
  end
end
