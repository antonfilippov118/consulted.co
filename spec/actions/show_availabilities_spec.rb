require File.dirname(__FILE__) + '/../spec_helper'

describe ShowsAvailabilities do
  before(:each) do
    User.delete_all
  end

  it 'should provide the availabilities for the current week' do
    u = user
    create_availability u
    result = ShowsAvailabilities.for user
    expect(result.success?).to be_true
    expect(result[:availabilities]).not_to be_nil
  end

  it 'should group the results by day of week for a given week' do
    u = user
    create_availability u
    result = ShowsAvailabilities.for u
    expect(result.success?).to be_true
    availabilities = result.fetch :availabilities

    day_of_week = Date.today.cwday

    expect(availabilities.length).to eq 7
    expect(availabilities[day_of_week - 1].class).to be Array
    expect(availabilities[day_of_week - 1].length).to eq 1
  end

  it 'should only fetch the availabilities for a given week' do
    u = user
    create_availability u
    create_availability u, starts: Time.now.midnight + 1.week, ends: Time.now.midnight + 1.week + 1.hour

    week = Date.today.cweek
    day_of_week = Date.today.cwday

    result = ShowsAvailabilities.for u, week + 1

    expect(result.success?).to be_true

    availabilities = result.fetch :availabilities
    expect(availabilities[day_of_week - 1].length).to eq 1
  end

  def user
    _user = User.create valid_params
  end

  def create_availability(user, opts = {}, modifier = 1)
    starts = Time.now.midnight + 10.hours
    ends   = starts + 60.minutes * modifier
    params = {
       starts: starts,
       ends: ends
    }
    opts = params.merge opts
    user.availabilities.create opts
  end
end
