require 'spec_helper'

describe CancelsPendingCalls do
  let(:action) { CancelsPendingCalls }

  it 'should decline calls which are pending and have not been responded to' do
    expert = User.create! valid_params.merge timezone: 'Europe/Berlin'
    user   = User.create! valid_params.merge timezone: 'Europe/Berlin', email: 'floriank@consulted.co'
    availability = expert.availabilities.create start: Time.now - 48.hours, end: Time.now
    call = Call.create active_from: availability.starting, expert: expert, length: 30, seeker: user

    call.created_at = Time.now - 127.hours
    call.save
    expect(Call.first.status).to eql Call::Status::REQUESTED

    result = action.older_than 24.hours

    expect(result.success?).to be_true
    expect(Call.first.status).to eql Call::Status::DECLINED
  end
end
