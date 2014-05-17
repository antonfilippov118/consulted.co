require 'spec_helper'

describe SendCallRatingReminder do
  let(:action) { SendCallRatingReminder }

  it 'should send a rating reminder to the seeker after the call has been marked as complete' do
    expert = User.create! valid_params.merge timezone: 'Europe/Berlin'
    user   = User.create! valid_params.merge timezone: 'Europe/Berlin', email: 'floriank@consulted.co'
    availability = expert.availabilities.create start: Time.now - 4.days, end: Time.now - 4.days + 75.minutes
    call = Call.create active_from: availability.starting, expert: expert, length: 30, seeker: user
    call.complete!

    deliveries.clear
    result = action.do

    expect(result.success?).to be_true
    expect(deliveries.length).to eql 1
    expect(deliveries.last.to).to eql [user.notification_email]
  end

  def deliveries
    ActionMailer::Base.deliveries
  end
end
