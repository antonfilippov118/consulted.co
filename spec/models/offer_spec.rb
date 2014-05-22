require 'spec_helper'

describe Offer do
  it 'should tell it\'s shortest duration' do
    offer = Offer.new lengths: %w(45 60 90 30)
    expect(offer.minimum_length).to eql 30
  end
end
