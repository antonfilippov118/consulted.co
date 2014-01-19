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
end
