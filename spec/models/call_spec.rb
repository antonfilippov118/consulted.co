require 'spec_helper'

describe Call do
  it 'should establish a connection to an expert availability upon creation' do
    user = expert
    availability = user.availabilities.first
    Call.create expert: user, seeker: seeker, length: 30, active_from: availability.starting
    call = Call.first
    expect(call.availability).to eql availability
  end

  describe 'blocking time' do
    it 'should block the availabilities of an expert when created' do
      user         = expert
      availability = user.availabilities.last
      offer        = user.offers.last
      Call.create expert: user, seeker: seeker, length: 30, active_from: availability.starting, offer: offer

      blocks = User.find(user).availabilities.first.blocks.map(&:status)
      expect(blocks[0..5]).to eql 6.times.map { 2 }
    end

    it 'should acknowledge the users break time by blocking additional time blocks' do
      user = expert
      user.break = 15
      user.save
      availability = user.availabilities.last
      offer        = user.offers.last
      Call.create expert: user, seeker: seeker, length: 30, active_from: availability.starting, offer: offer

      # reload
      blocks = User.find(user).availabilities.first.blocks.map(&:status)
      expect(blocks[0..8]).to eql 9.times.map { 2 }
    end
  end

  describe 'calculating payment, rate and fee' do
    {
      30 => 100,
      45 => 150,
      60 => 200,
      90 => 300,
      120 => 400
    }.each_pair do |min, cost|
      it "should calculate it's total cost correctly for a length of #{min} minutes" do
        user         = expert
        availability = user.availabilities.last
        offer        = user.offers.last
        Call.create expert: user, seeker: seeker, length: min, active_from: availability.starting, offer: offer # rate 200
        call = Call.first
        expect(call.cost).to eql cost * 100 # cents
      end
    end

    {
      30 => 15,
      45 => 22.5,
      60 => 30,
      90 => 45,
      120 => 60
    }.each_pair do |min, fee|
      it "should calculate it's fee based on the current platform settings for a length of #{min} minutes" do
        user         = expert
        availability = user.availabilities.last
        offer        = user.offers.last
        Call.create expert: user, seeker: seeker, length: min, active_from: availability.starting, offer: offer # rate 200
        call = Call.first
        expect(call.fee).to eql((fee * 100).to_i) # cents
      end
    end

    {
      30  => 85,
      45  => 127.5,
      60  => 170,
      90  => 255,
      120 => 340
    }.each_pair do |min, rate|
      it "should calculate the rate (the amount to be paid out) based on the platform settings for #{min} minutes" do
        user         = expert
        availability = user.availabilities.last
        offer        = user.offers.last
        Call.create expert: user, seeker: seeker, length: min, active_from: availability.starting, offer: offer # rate 200
        call = Call.first
        expect(call.rate).to eql((rate * 100).to_i) # cents
      end
    end
  end

  describe 'when generating access codes' do
    it 'should create a unique 6-digit code' do
      call = Call.new
      expect(call.pin).to be_an Integer
      expect(100_000..999_999).to cover(call.pin)
    end

    it 'should prevent collisions with active pins' do
      user         = expert
      offer        = user.offers.last
      Call.create expert: user, seeker: seeker, length: 120, active_from: Time.now, offer: offer # rate 200
      call = Call.last
      call.confirm!
      second_call = Call.create pin: call.pin, expert: user, seeker: seeker, length: 30, active_from: Time.now, offer: offer
      expect(second_call.pin).not_to eql call.pin
    end
  end

  def seeker
    user = User.create valid_params
    user.confirm!
    user
  end

  def group
    Group.create name: 'Finance'
  end

  def expert
    expert = User.new valid_params.merge email: 'florian@consulted.co', break: 0
    expert.linkedin_network = 10_000
    expert.providers = %w(linkedin)
    expert.save
    expert.confirm!

    expert.offers.create group: group, rate: 200, experience: 20, description: 'foo'
    expert.availabilities.create start: Time.now, end: Time.now + 180.minutes
    expert
  end
end
