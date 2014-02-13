require File.dirname(__FILE__) + '/../spec_helper'

describe ShowsAvailabilities do
  before(:each) do
    User.delete_all
    Availability.delete_all
  end

  context 'for non expert user' do
    it 'should fail' do
      user = User.create valid_params
      user.confirm!
      result = ShowsAvailabilities.for(user)

      expect(result.success?).to be_false
    end

    it 'should fail when unconfirmed' do
      user = User.create valid_params
      result = ShowsAvailabilities.for(user)

      expect(result.success?).to be_false
    end
  end

  context 'for expert user' do
    it 'should be successful' do
      u = user
      result = ShowsAvailabilities.for(u)
      expect(result.success?).to be_true
    end

    it 'should provide the availabilities for the current week' do
      u = user
      create_availability user: u
      result = ShowsAvailabilities.for user
      expect(result[:week]).not_to be_nil
    end

    it 'should group the results by day of week for a given week' do
      u = user
      create_availability user: u
      result = ShowsAvailabilities.for u
      week   = result[:week]
      expect(week.length).to eql 7
      current_day_of_week  = Date.today.cwday - 1
      availabilities_today = week[current_day_of_week]
      expect(availabilities_today.length).to eql(1)
    end

    it 'should onyl fetch the availabilities for a given week' do
      u = user
      create_availability user: u

      opts = {
        starts: DateTime.now + 1.week + 1.day,
        ends: DateTime.now + 1.week + 1.day,
        user: u
      }
      create_availability opts
      current_week = Date.today.cweek
      current_day  = Date.today.cwday

      result = ShowsAvailabilities.for u, current_week
      week   = result[:week]
      expect(week[current_day - 1].length).to eql 1

      result = ShowsAvailabilities.for u, current_week + 1
      week   = result[:week]
      expect(week[current_day].length).to eql(1)
    end

    def user
      _user = User.create valid_params
      _user.linkedin_network = 10_000
      _user.confirm!
      _user
    end

    def create_availability(opts = {})
      params = {
         starts: Time.now,
         ends: Time.now + 60.minutes
      }
      opts = params.merge opts
      Availability.create opts
    end
  end
end
