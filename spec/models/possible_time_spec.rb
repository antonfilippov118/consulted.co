require File.dirname(__FILE__) + '/../spec_helper'

describe PossibleTime do

  it 'should belong to a user' do
    should belong_to(:user)
  end

  it 'has a length' do
    expect do
      PossibleTime.new.length = 120
    end.not_to raise_error
  end

  it 'should only allow specific lengths' do
    time = PossibleTime.new
    time.length = 90

    expect(time.valid?).to be_true

    time = PossibleTime.new
    time.length = 117

    expect(time.valid?).to be_false
  end

  it 'should need a user' do
    time = PossibleTime.new
    time.length = 30
    expect(time.valid?).to be_false
  end
end
