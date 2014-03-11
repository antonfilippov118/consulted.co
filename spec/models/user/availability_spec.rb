require File.dirname(__FILE__) + '/../../spec_helper'

describe User::Availability do
  before(:each) do
    User.delete_all
  end

  it 'should automatically saves the week based on it\'s start date' do
    availability = create_availability
    availability.save
    expect(availability.week).to eql(DateTime.now.cweek)
  end

  it 'should be found by week' do
    week = DateTime.now.cweek
    availability = create_availability
    availability.save

    result = User.first.availabilities.in_week week

    expect(result.length).to eql(1)
  end

  def create_availability
    starts = DateTime.now
    ends   = starts + 4.hours
    user.availabilities.create starts: starts, ends: ends, user: user
  end

  def user
    User.create valid_params
  end
end
