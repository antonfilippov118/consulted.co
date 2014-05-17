require 'spec_helper'

describe Call do
  it 'should create blocks for the expert when confirmed' do
    availability = expert.availabilities.first
    call = Call.new seeker: seeker,
                    expert: expert,
                    active_from: availability.starting,
                    length: 45
    call.save
    call.confirm!
    blocks = User.last.availabilities.first.blocks.map(&:status)

    expect(blocks[0..8]).to eql 9.times.map { 2 }
  end

  it 'should free the blocks for the expert after destruction' do
    availability = expert.availabilities.first
    call = Call.new seeker: seeker,
                    expert: expert,
                    active_from: availability.starting,
                    length: 45
    call.save
    call.confirm!
    call.destroy
    blocks = User.last.availabilities.first.blocks.map(&:status)

    expect(blocks[0..8]).to eql 9.times.map { 0 }
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
    expert = User.new valid_params.merge email: 'florian@consulted.co'
    expert.linkedin_network = 10_000
    expert.providers = %w(linkedin)
    expert.save
    expert.confirm!

    expert.offers.create group: group, rate: 200, experience: 20, description: 'foo'
    expert.availabilities.create start: Time.now, end: Time.now + 50.minutes
    expert
  end
end
