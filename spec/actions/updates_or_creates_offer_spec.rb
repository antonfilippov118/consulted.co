require File.dirname(__FILE__) + '/../spec_helper'

describe UpdatesOrCreatesOffer do
  before(:each) do
    Group.delete_all
    User.delete_all

    Group.create name: 'Bingo'
  end
  it 'should create an offer for a given user when the user does not have an offer in the group' do
    user = User.create valid_params.merge linkedin_network: 100_000
    user.confirm!

    result = UpdatesOrCreatesOffer.for user, offer_params

    expect(result.success?).to be_true
    expect(user.offers.count).to eq 1
  end

  it 'should update an existing offer' do
    user = User.create valid_params.merge linkedin_network: 100_000
    user.confirm!

    user.offers.create group: Group.first, description: 'lorem', experience: 12, rate: 30, enabled: false

    result = UpdatesOrCreatesOffer.for user, offer_params

    expect(result.success?).to be_true
    expect(user.offers.count).to eq 1
    offer = User.first.offers.first
    expect(offer.experience).to eq 25
    expect(offer.rate).to eq 10
    expect(offer.enabled).to be_true
    expect(offer.name).to eq 'Bingo'
  end

  def offer_params
    {
      slug: Group.first.slug,
      description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ab, quisquam, voluptas illum recusandae officiis non amet molestiae voluptate laudantium numquam nostrum facilis! Ipsa, iusto, dignissimos ipsam fuga incidunt dolorem quas!',
      experience: 25,
      rate: 10,
      enabled: true
    }
  end
end
