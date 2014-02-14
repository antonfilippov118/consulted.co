require File.dirname(__FILE__) + '/../spec_helper'

class SearchServiceOffers
  include LightService::Organizer
  def self.with_options(options = {})
    with(options).reduce [

    ]
  end
end

describe SearchServiceOffers do
  before(:each) do
    User.delete_all
    Offer.delete_all
  end
  before(:each) do
    Offer
  end
  it 'should find offers by other users' do
    periods = [
      {
        starts: '2014-01-12 8:00+01:00',
        ends: '2014-01-12 16:00+01:00'
      },
      {
        starts: '2014-01-13 13:00+01:00',
        ends: '2014-01-13 13:30+01:00'
      }
    ]

    result = SearchServiceOffers.with_options for: periods
    expect(result.success?).to be_true
  end
end
