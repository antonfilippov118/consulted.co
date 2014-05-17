require 'spec_helper'

describe SendCallReminders do
  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  let(:action) { SendCallReminders }

  it 'should sent a call reminder prior to the call to expert and seeker' do
    expert = User.create! valid_params.merge timezone: 'Europe/Berlin'
    user   = User.create! valid_params.merge timezone: 'Europe/Berlin', email: 'floriank@consulted.co'
    availability = expert.availabilities.create start: Time.now + 15.minutes, end: Time.now + 75.minutes
    call = Call.create active_from: availability.starting, expert: expert, length: 30, seeker: user
    call.confirm!

    deliveries.clear
    result = action.do

    expect(result.success?).to be_true
    expect(deliveries.length).to eql 2
  end

  it 'should send a reminder to the seeker if the expert has already been notified' do
    expert = User.create! valid_params.merge timezone: 'Europe/Berlin'
    user   = User.create! valid_params.merge timezone: 'Europe/Berlin', email: 'floriank@consulted.co'
    availability = expert.availabilities.create start: Time.now + 15.minutes, end: Time.now + 75.minutes
    call = Call.create active_from: availability.starting, expert: expert, length: 30, seeker: user, expert_reminder_sent: true
    call.confirm!

    deliveries.clear
    result = action.do

    expect(result.success?).to be_true
    expect(deliveries.length).to eql 1
    expect(deliveries.last.to).to eql [user.notification_email]
  end

  it 'should send a reminder to the expert if the seeker has already been notified' do
    expert = User.create! valid_params.merge timezone: 'Europe/Berlin'
    user   = User.create! valid_params.merge timezone: 'Europe/Berlin', email: 'floriank@consulted.co'
    availability = expert.availabilities.create start: Time.now + 15.minutes, end: Time.now + 75.minutes
    call = Call.create active_from: availability.starting, expert: expert, length: 30, seeker: user, seeker_reminder_sent: true
    call.confirm!

    deliveries.clear
    result = action.do

    expect(result.success?).to be_true
    expect(deliveries.length).to eql 1
    expect(deliveries.last.to).to eql [expert.notification_email]
  end

  it 'should not send antything when both call partner have been notified' do
    expert = User.create! valid_params.merge timezone: 'Europe/Berlin'
    user   = User.create! valid_params.merge timezone: 'Europe/Berlin', email: 'floriank@consulted.co'
    availability = expert.availabilities.create start: Time.now + 15.minutes, end: Time.now + 75.minutes
    call = Call.create active_from: availability.starting, expert: expert, length: 30, seeker: user, expert_reminder_sent: true, seeker_reminder_sent: true
    call.confirm!

    deliveries.clear
    result = action.do

    expect(result.success?).to be_true
    expect(deliveries.length).to eql 0
  end

  def deliveries
    ActionMailer::Base.deliveries
  end
end
