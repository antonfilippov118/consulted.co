
require 'spec_helper'

describe FindExpertTimes do
  before(:each) do
    Group.create name: 'Foo'
  end

  let(:action) { FindExpertTimes }

  it 'should map out times available for experts with a given offer' do
    user = expert
    result = action.for user.offer.first, 30

    expect(result.success?).to be_true
    times = result.fetch :times
    expect(times).to be_an Array
    expect(times.length).to eql 3
  end

  def expert
    expert = User.create valid_params # start_delay is 30 minutes, break time is 15 minutes
    expert.offers.create group: Group.first, lengths: %w(30 60), rate: 100, experience: 30, description: 'foo'
    expert.availabilities.create start: Time.now, end: Time.now + 2.hours
    expert
  end
end
