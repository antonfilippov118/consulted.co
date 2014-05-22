
require 'spec_helper'

describe FindsExpertTimes do

  let(:action) { FindsExpertTimes }

  describe 'when finding time with a given user with avilabilities and no calls' do
    describe 'in the future' do
      {
        30 => 1,
        45 => 1,
        60 => 1,
        90 => 0,
        120 => 0
      }.each_pair do |min, length|
        it "should map out times available for experts for #{min} minute calls" do
          result = action.for expert, min.minutes

          expect(result.success?).to be_true
          times = result.fetch :times
          expect(times).to be_an Array
          expect(times.length).to eql length
        end
      end
    end

    describe 'in the past' do
      it 'should ignore availabilities in the past' do
        user = expert
        user.availabilities.create start: Time.now - 1.day, end: Time.now - 22.hours
        result = action.for user, 30.minutes
        expect(result.success?).to be_true
        times = result.fetch :times
        expect(times.length).to eql 1
      end
    end
  end

  describe 'when finding time with a given user and calls present' do
    it 'should acknowledge call requests present' do
      user = expert
      offer = user.offers.create group: group, lengths: %w(30 45 60), experience: 20, rate: 3000, description: 'foo'
      start = user.availabilities.first.starting
      Call.create! offer: offer, length: 30, seeker: seeker, expert: user, message: 'Test call', active_from: start + 35.minutes
      binding.pry

      result = action.for user, 30.minutes
      expect(result.success?).to be_true
    end
  end

  def expert
    expert = User.create valid_params # start_delay is 30 minutes, break time is 15 minutes
    expert.availabilities.create start: Time.now, end: Time.now + 2.hours
    expert
  end

  def seeker
    User.create valid_params.merge email: 'floriank@consulted.co'
  end

  def group
    Group.create name: 'finance'
  end
end
