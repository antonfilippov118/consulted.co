require 'spec_helper'

describe Call do
  it 'should establish a connection to an expert availability upon creation' do
    user = expert
    availability = user.availabilities.first
    Call.create expert: user, seeker: seeker, length: 30, active_from: availability.starting
    call = Call.first
    expect(call.availability).to eql availability
  end

  describe 'blocking time' do
    it 'should block the availabilities of an expert when created' do
      user = expert
      availability = user.availabilities.last
      offer = user.offers.last
      Call.create expert: user, seeker: seeker, length: 30, active_from: availability.starting, offer: offer

      blocks = User.find(user).availabilities.first.blocks.map(&:status)
      expect(blocks[0..5]).to eql 6.times.map { 2 }
    end

    it 'should acknowledge the users break time by blocking additional time blocks' do
      user = expert
      user.break = 15
      user.save
      availability = user.availabilities.last
      offer = user.offers.last
      Call.create expert: user, seeker: seeker, length: 30, active_from: availability.starting, offer: offer

      # reload
      blocks = User.find(user).availabilities.first.blocks.map(&:status)
      expect(blocks[0..8]).to eql 9.times.map { 2 }
      expect(blocks[9]).to eql 0
    end
  end

  describe 'calculating payment, rate and fee' do
    {
        30 => 100,
        45 => 150,
        60 => 200,
        90 => 300,
        120 => 400
    }.each_pair do |min, cost|
      it "should calculate it's total cost correctly for a length of #{min} minutes" do
        user = expert
        availability = user.availabilities.last
        offer = user.offers.last
        Call.create expert: user, seeker: seeker, length: min, active_from: availability.starting, offer: offer # rate 200
        call = Call.first
        expect(call.cost).to eql cost * 100 # cents
      end
    end

    {
        30 => 15,
        45 => 22.5,
        60 => 30,
        90 => 45,
        120 => 60
    }.each_pair do |min, fee|
      it "should calculate it's fee based on the current platform settings for a length of #{min} minutes" do
        user = expert
        availability = user.availabilities.last
        offer = user.offers.last
        Call.create expert: user, seeker: seeker, length: min, active_from: availability.starting, offer: offer # rate 200
        call = Call.first
        expect(call.fee).to eql((fee * 100).to_i) # cents
      end
    end

    {
        30 => 85,
        45 => 127.5,
        60 => 170,
        90 => 255,
        120 => 340
    }.each_pair do |min, rate|
      it "should calculate the rate (the amount to be paid out) based on the platform settings for #{min} minutes" do
        user = expert
        availability = user.availabilities.last
        offer = user.offers.last
        Call.create expert: user, seeker: seeker, length: min, active_from: availability.starting, offer: offer # rate 200
        call = Call.first
        expect(call.rate).to eql((rate * 100).to_i) # cents
      end
    end
  end

  describe 'when generating access codes' do
    it 'should create a unique 6-digit code' do
      call = Call.new
      expect(call.pin).to be_an Integer
      expect(100_000..999_999).to cover(call.pin)
    end

    it 'should prevent collisions with active pins' do
      user = expert
      offer = user.offers.last
      Call.create expert: user, seeker: seeker, length: 120, active_from: Time.now, offer: offer # rate 200
      call = Call.last
      call.confirm!
      second_call = Call.create pin: call.pin, expert: user, seeker: seeker, length: 30, active_from: Time.now, offer: offer
      expect(second_call.pin).not_to eql call.pin
    end
  end

  describe 'creating invoice' do
    before(:each) { Invoice.any_instance.stub(:create_pdf) }
    let(:call) { Call.create expert: expert, seeker: seeker, length: 120, active_from: Time.now, offer: expert.offers.first }

    it 'should create invoice' do
      call.create_invoice
      expect(call.invoice).not_to be_blank
    end

    it 'should generate pdf invoice' do
      Invoice.any_instance.should_receive(:create_pdf).once
      call.create_invoice
    end

    it 'should not create invoice when pdf creation failed' do
      Invoice.any_instance.stub(:create_pdf).and_raise('Bad Error')
      expect do
        expect do
          call.create_invoice
        end.to raise_error 'Bad Error'
      end.not_to change(Invoice, :count)
      expect(call.invoice).to be_blank
    end
  end

  describe 'creating review' do
    let(:call) { Call.create expert: expert, seeker: seeker, length: 120, active_from: Time.now, offer: expert.offers.first }
    let(:valid_attrs) do
      {
          awesome: true,
          understood_problem: 3,
          helped_solve_problem: 1,
          knowledgeable: 4,
          value_for_money: 2,
          would_recommend: 5,
          would_recommend_consulted: 9,
          feedback: 'Good!'
      }
    end

    it 'should not be can_be_reviewed? if it is not completed' do
      call.update({ status: Call::Status::ACTIVE})
      expect(call.can_be_reviewed?).to be_false
    end

    it 'should be can_be_reviewed? if it is completed and has no reviews' do
      call.update({ status: Call::Status::COMPLETED})
      expect(call.can_be_reviewed?).to be_true
    end

    it 'should not be can_be_reviewed? if it is completed and already has review' do
      call.update({ status: Call::Status::COMPLETED})
      call.create_review
      expect(call.can_be_reviewed?).to be_false
    end

    it 'should create review' do
      call.create_review
      expect(call.review).not_to be_blank
    end

    it 'should create review with an offer attached from the call' do
      call.create_review
      expect(call.review.offer).to eq call.offer
    end

    it 'should create review with correct call set' do
      call.create_review
      expect(call.review.call).to eq call
    end

    it 'should pass attributes to the review (and the offer)' do
      Review.should_receive(:create!).with(valid_attrs.merge({ offer: call.offer })).and_call_original
      call.create_review(valid_attrs)
    end

    it 'should raise error if review creation fails' do
      Review.stub(:create!).and_raise('Validation Error')
      expect { call.create_review(valid_attrs) }.to raise_error 'Validation Error'
    end
  end


  def seeker
    user = User.create valid_params
    user.confirm!
    user
  end

  def group
    Group.create name: 'Finance'
  end

  def expert
    expert = User.new valid_params.merge email: 'florian@consulted.co', break: 0
    expert.linkedin_network = 10_000
    expert.providers = %w(linkedin)
    expert.save
    expert.confirm!

    expert.offers.create group: group, rate: 200, experience: 20, description: 'foo'
    expert.availabilities.create start: Time.now, end: Time.now + 180.minutes
    expert
  end
end
