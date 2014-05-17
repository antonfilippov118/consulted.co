require 'spec_helper'

describe CompletesCalls do
  let(:action) { CompletesCalls }
  it 'should complete calls which have passed their active time by 30 minutes' do
    expert = User.create! valid_params.merge timezone: 'Europe/Berlin'
    user   = User.create! valid_params.merge timezone: 'Europe/Berlin', email: 'floriank@consulted.co'
    availability = expert.availabilities.create start: Time.now - 4.days, end: Time.now - 4.days + 75.minutes
    call = Call.create active_from: availability.starting, expert: expert, length: 30, seeker: user
    call.confirm!
    result = action.do

    expect(result.success?)
    expect(Call.active.count).to eql 0
    expect(Call.completed.count).to eql 1
  end
end
