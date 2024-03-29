require 'spec_helper'

describe Availability do
  it 'should generate timeblocks in 5 minute intervals' do
    user = User.create valid_params
    a = Availability.new user: user, start: Time.now, end: Time.now + 60.minutes
    a.save

    expect(a.blocks.length).to eql 12
  end

  it 'should create more timeblocks when changed' do
    user = User.create valid_params
    a = Availability.new user: user, start: Time.now, end: Time.now + 60.minutes
    a.save

    expect(a.blocks.length).to eql 12

    a.ending = a.ending + 20.minutes
    a.save
    expect(a.blocks.count).to eql 16
  end

  it 'should decrease the count of time blocks when edited, if necessary' do
    user = User.create valid_params
    a = Availability.new user: user, start: Time.now, end: Time.now + 60.minutes
    a.save

    expect(a.blocks.length).to eql 12

    a.ending = a.ending - 20.minutes
    a.save
    expect(a.blocks.count).to eql 8
  end

  it 'should be able to set the booked state for it\'s blocks' do
    user = User.create valid_params
    a = Availability.new user: user, start: Time.now, end: Time.now + 15.minutes
    a.save

    a.book! a.starting, 15

    expect(Availability.first.blocks.map(&:status)).to eql 3.times.map { Availability::TimeBlock::Status::BOOKED }
  end

  it 'should be able to set the blocked state for it\'s blocks' do
    user = User.create valid_params
    a = Availability.new user: user, start: Time.now, end: Time.now + 25.minutes
    a.save

    a.block! a.starting, 15

    expect(Availability.first.blocks.map(&:status)).to eql [1, 1, 1, 0, 0]
  end

  it 'should be able to tell about the maximum possible call length' do
    user = User.create valid_params
    a = Availability.new user: user, start: Time.now, end: Time.now + 50.minutes
    a.save
    group = Group.create name: 'foo'
    offer = user.offers.create rate: 200, experience: 30, group: group, lengths: [30, 45, 90, 120]

    expect(a.maximum_call_length(offer)).to eql 45
  end

  it 'should deliver the maximum call length' do
    user = User.create valid_params.merge start_delay: 0
    a = Availability.new user: user, start: Time.now, end: Time.now + 150.minutes
    a.save
    group = Group.create name: 'foo'
    offer = user.offers.create rate: 200, experience: 30, group: group, lengths: [30, 45, 90, 120]

    expect(a.maximum_call_length(offer)).to eql 120
  end

  it 'should include the start delay' do
    user = User.create valid_params.merge start_delay: 10
    a = Availability.new user: user, start: Time.now, end: Time.now + 60.minutes
    a.save

    expect(a.next_possible_time).to be_a Time
    expect(a.next_possible_time).to eql Time.at(a.starting + 15.minutes)
  end

  context 'when querying calls' do
    it 'should tell if a call fits into the availability' do
      user = User.create valid_params
      a = Availability.new user: user, start: Time.now, end: Time.now + 60.minutes
      a.save

      expect(a.call_possible?).to be_true
    end

    it 'should tell if a call is not possible within the availability' do
      user = User.create valid_params
      a = Availability.new user: user, start: Time.now, end: Time.now + 15.minutes
      a.save

      expect(a.call_possible?).to be_false
    end

    it 'should tell if a call is possible if some of its blocks are blocked' do
      user = User.create valid_params
      a = Availability.new user: user, start: Time.now, end: Time.now + 35.minutes
      a.save

      a.blocks.last.block!

      expect(a.call_possible?).to be_true
    end

    it 'should tell if a call is possible if multiple blocks are blocked' do
      user = User.create valid_params.merge start_delay: 0
      a = Availability.new user: user, start: Time.now, end: Time.now + 35.minutes
      a.save

      a.blocks[3].block!
      expect(a.call_possible?).to be_false
    end

    it 'should tell when the next call is possible with the current configuration' do
      user = User.create valid_params.merge start_delay: 10
      a = Availability.new user: user, start: Time.now, end: Time.now + 120.minutes
      a.save

      a.blocks[3..10].each(&:block!)

      expect(a.next_possible_time).to be_a Time
      expect(a.next_possible_time).to eql Time.at(a.blocks[11].start)
    end

    it 'should tell when no next call is possible' do
      user = User.create valid_params.merge start_delay: 0
      a = Availability.new user: user, start: Time.now, end: Time.now + 60.minutes
      a.save

      a.blocks.each(&:block!)

      expect(a.next_possible_time).to be_false
    end
  end
end
