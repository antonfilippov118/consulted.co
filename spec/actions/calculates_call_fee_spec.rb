require 'spec_helper'
describe CalculatesCallFee do
  let(:action) { CalculatesCallFee }
  it 'should not calculate a fee for any call other than cancelled calls' do
    c = Call.new
    result = action.for c
    expect(result.success?).to be_true
    expect(result.fetch(:fee)).to eql 0
  end

  it 'should calculate a 10% fee for a call if it is cancelled and 24 hours or more before the meeting starts' do
    user = User.create valid_params
    user.offers.create rate: 1000, group: Group.create(name: 'Foo')

    c = Call.new active_from: Time.now + 30.hours, offer: user.offers.first, length: 30, expert: user, seeker: user
    c.save
    c.cancel!
    result = action.for c
    expect(result.fetch(:fee)).to eql 100.0
  end

  it 'should calculate a fee of 50% if the call is less than 24 hours away' do
    user = User.create valid_params
    user.offers.create rate: 1000, group: Group.create(name: 'Foo')

    c = Call.new active_from: Time.now + 3.hours, offer: user.offers.first, length: 30, expert: user, seeker: user
    c.save
    c.cancel!
    result = action.for c
    expect(result.fetch(:fee)).to eql 500.0
  end
end
