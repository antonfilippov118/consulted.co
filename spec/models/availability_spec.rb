require 'spec_helper'

describe Availability do
  it 'should generate timeblocks in 5 minute intervals' do
    user = User.create valid_params
    a = Availability.new user: user, start: Time.now, end: Time.now + 60.minutes
    a.save

    expect(a.blocks.length).to eql 12
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
      user = User.create valid_params
      a = Availability.new user: user, start: Time.now, end: Time.now + 35.minutes
      a.save

      a.blocks[3].block!
      expect(a.call_possible?).to be_false
    end

    it 'should tell when the next call is possible with the current configuration' do
      user = User.create valid_params
      a = Availability.new user: user, start: Time.now, end: Time.now + 120.minutes
      a.save

      a.blocks[3..10].each(&:block!)

      expect(a.next_possible_time).to be_a Time
      expect(a.next_possible_time).to eql Time.at(a.blocks[11].start)
    end

    it 'should tell when no next call is possible' do
      user = User.create valid_params
      a = Availability.new user: user, start: Time.now, end: Time.now + 60.minutes
      a.save

      a.blocks.each(&:block!)

      expect(a.next_possible_time).to be_false
    end
  end
end
