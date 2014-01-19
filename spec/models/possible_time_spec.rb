require File.dirname(__FILE__) + '/../spec_helper'

describe PossibleTime do
  it 'should belong to a user' do
    should belong_to(:user)
  end
end
