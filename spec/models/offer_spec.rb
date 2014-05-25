require 'spec_helper'

describe Offer do
  it 'should tell it\'s shortest duration' do
    offer = Offer.new lengths: %w(45 60 90 30)
    expect(offer.minimum_length).to eql 30

    offer = Offer.new lengths: %w(120 60 90)
    expect(offer.minimum_length).to eql 60

    offer = Offer.new lengths: %w()
    expect(offer.minimum_length).to eql 0
  end

  it 'should tell it\'s longest possible duration' do
    offer = Offer.new lengths: %w(45 60 90 30)
    expect(offer.maximum_length).to eql 90

    offer = Offer.new lengths: %w(120 60 90)
    expect(offer.maximum_length).to eql 120

    offer = Offer.new lengths: %w()
    expect(offer.maximum_length).to eql 0
  end
end
