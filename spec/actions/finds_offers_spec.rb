require File.dirname(__FILE__) + '/../spec_helper'

describe FindsOffers do
  before(:each) do
    Group.delete_all
    User.delete_all
  end
end
