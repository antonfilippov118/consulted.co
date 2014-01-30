require File.dirname(__FILE__) + '/../spec_helper'

describe UpdatesOffers do
  before(:each) do
    User.delete_all
    Offer.delete_all
  end

  it 'should not allow an update for an unconfirmed user' do
    user = create_unconfirmed_user!
    result = UpdatesOffers.for user, {}
    expect(result.failure?).to be_true
  end

  it 'should not allow the creation of offers for any non expert' do
    user = create_user!
    result = UpdatesOffers.for user, {}
    expect(result.failure?).to be_true
  end

  it 'should allow the creation of offers for expert users' do
    user = create_expert!
    result = UpdatesOffers.for user, {}
    expect(result.success?).to be_true
    expect(user.offers.length).to eql(0)
  end

  it 'should create groups for the expert' do
    group  = Group.create name: 'TestGroup'
    user   = create_expert!
    result = UpdatesOffers.for user, [
      {
        '_group_id' => group.id,
        'description' => 'Foo',
        'experience' => 5,
        'rate' => 50,
        'lengths' => %W( 30 60 120 )
      }
    ]
    expect(result.success?).to be_true
    expect(User.first.offers.length).to eql(1)
  end

  it 'should update existing groups for the expert' do
    group = Group.create name: 'Foo'
    user  = create_expert!
    offer = Offer.new group: group, description: 'Foo', rate: 50, lengths: ['60'], experience: 1
    user.offers << offer

    result = UpdatesOffers.for user, [
      {
        '_group_id' => group.id,
        'description' => 'Bar',
        'rate' => 60,
        'lengths' => %W( 30 )
      }
    ]

    expect(result.success?).to be_true
    expect(User.first.offers.count).to eql(1)

    offer = User.first.offers.first
    expect(offer.description).to eql('Bar')
    expect(offer.rate).to eql(60)
    expect(offer.lengths).to eql(%W( 30 ))
  end

  it 'should create offers with groups not yet attached to the expert' do
    group_1 = Group.create name: 'Foo'
    group_2 = Group.create name: 'Bar'
    user    = create_expert!
    offer   = Offer.new group: group_1, description: 'Foo', rate: 50, lengths: ['60'], experience: 1
    user.offers << offer

    result = UpdatesOffers.for user, [
      {
        '_group_id' => group_1.id,
        'description' => 'Baz',
        'rate' => '60',
        'lengths' => %W( 60 ),
        'experience' => '2'
      },
      {
        '_group_id' => group_2.id,
        'description' => 'Foo',
        'rate' => '80',
        'lengths' => %W( 120 ),
        'experience' => '1'
      }
    ]
    expect(result.success?).to be_true
    user = User.first
    expect(user.offers.count).to eql(2)
    offer_1 = user.offers.first
    offer_2 = user.offers.last

    expect(offer_1.description).to eql('Baz')
    expect(offer_1.rate).to eql(60)

    expect(offer_2.rate).to eql(80)
    expect(offer_2.experience).to eql(1)
    expect(offer_2.lengths).to eql(%W( 120 ))
  end

  def valid_params
    {
      email: 'florian@consulted.co',
      name: 'Florian',
      password: 'tester',
      password_confirmation: 'tester',
      confirmation_sent_at: Time.now
    }
  end

  def create_user!
    user = User.create valid_params
    user.confirm!
    user
  end

  def create_unconfirmed_user!
    User.create valid_params
  end

  def create_expert!
    user = User.create valid_params
    user.confirm!
    user.linkedin_network = 10_000
    user
  end
end
