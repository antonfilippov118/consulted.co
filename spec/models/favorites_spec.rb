require File.dirname(__FILE__) + '/../spec_helper'

describe Favorites do
  before(:each) do
    Favorites.delete_all
    User.delete_all
  end

  it 'should have the logged in user as first param' do

  end

  it

  it 'should automatically saves the week based on it\'s start date' do
    availability = create_availability
    availability.save
    expect(availability.week).to eql(DateTime.now.cweek)
  end

end
