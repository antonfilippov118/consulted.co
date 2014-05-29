require File.dirname(__FILE__) + '/../spec_helper'

describe UpdatesOrCreatesAvailability do
  let(:action) { UpdatesOrCreatesAvailability }
  it 'should create a new availability when requested without an id' do
    user = User.create valid_params
    result = action.for user, start: (Time.now.to_i), end: ((Time.now + 60.minutes).to_i)
    expect(result.success?).to be_true
    expect(user.availabilities.count).to eql 1
  end

  it 'should update an existing availability' do
    user = User.create valid_params
    availability = user.availabilities.create start: Time.now, end: Time.now + 1.hour
    id = availability.id.to_s

    result = action.for user, id: id, start: (Time.now.to_i), end: ((Time.now + 60.minutes).to_i)
    expect(result.success?).to be_true
    expect(user.availabilities.count).to eql 1
  end

  it 'should create a new availability when requested with a false id' do
    user = User.create valid_params
    result = action.for user, id: 'foo', start: (Time.now.to_i), end: ((Time.now + 60.minutes).to_i)
    expect(result.success?).to be_true
    expect(user.availabilities.count).to eql 1
  end

  it 'should update an existing availability with the times given' do
    user = User.create valid_params
    result = action.for user, start: (Time.now.to_i), end: ((Time.now + 60.minutes).to_i)

    availability = result.fetch :availability
    id           = availability.id.to_s
    start        = availability.starting
    ending       = availability.ending

    result = action.for user, id: id, start: ((start - 10.minutes).to_i), end: ((ending + 10.minutes).to_i)
    new_availability =  result.fetch :availability

    expect(new_availability.starting).to eql start - 10.minutes
    expect(new_availability.ending).to eql ending + 10.minutes
  end
end
