require 'spec_helper'

describe CancelsCall do
  let(:action) { CancelsCall }

  describe 'changing call status' do
    it 'should set a requested call to declined' do
      c = Call.new call_params

      result = action.for c, expert

      expect(result.success?).to be_true
      call = result.fetch :call
      expect(call.declined?).to be_true
    end

    it 'should cancel a call which is already active' do
      c = Call.new call_params.merge status: Call::Status::ACTIVE
      result = action.for c, expert
      call = result.fetch :call
      expect(call.cancelled?).to be_true
    end
  end

  describe 'sending emails' do
    let(:call) do
      c = Call.new call_params
      deliveries.clear
      c
    end

    it 'should send emails to the expert and the seeker when the expert declines' do
      action.for call, expert
      expect(deliveries.count).to eql 2
      seeker_mail, expert_mail = deliveries.first, deliveries.last
      expect(seeker_mail.to).to eql %w(seeker@consulted.co)
      expect(expert_mail.to).to eql %w(florian@consulted.co)
      expect(seeker_mail.subject).to eql 'call_declined_by_expert_to_seeker'
      expect(expert_mail.subject).to eql 'call_declined_by_expert_manually'
    end

    it 'should send emails to the expert and the seeker when the seeker abandons the call' do
      action.for call, seeker
      expect(deliveries.count).to eql 2
      seeker_mail, expert_mail = deliveries.first, deliveries.last
      expect(seeker_mail.to).to eql %w(seeker@consulted.co)
      expect(expert_mail.to).to eql %w(florian@consulted.co)
      expect(seeker_mail.subject).to eql 'call_abandoned_by_seeker_to_seeker'
      expect(expert_mail.subject).to eql 'call_abandoned_by_seeker_to_expert'
    end

    it 'should send emails to expert and seeker when the expert cancel a confirmed call' do
      call.confirm!
      result = action.for call, expert
      expect(result.success?).to be_true
      expect(deliveries.count).to eql 2
      seeker_mail, expert_mail = deliveries.first, deliveries.last
      expect(seeker_mail.to).to eql %w(seeker@consulted.co)
      expect(expert_mail.to).to eql %w(florian@consulted.co)
      expect(seeker_mail.subject).to eql 'call_cancelled_by_expert_to_seeker'
      expect(expert_mail.subject).to eql 'call_cancelled_by_expert_to_expert'
    end

    it 'should send emails to expert and seeker when the seeker cancel a confirmed call' do
      call.confirm!
      result = action.for call, seeker
      expect(result.success?).to be_true
      expect(deliveries.count).to eql 2
      seeker_mail, expert_mail = deliveries.first, deliveries.last
      expect(seeker_mail.to).to eql %w(seeker@consulted.co)
      expect(expert_mail.to).to eql %w(florian@consulted.co)
      expect(seeker_mail.subject).to eql 'call_cancelled_by_seeker_to_seeker'
      expect(expert_mail.subject).to eql 'call_cancelled_by_seeker_to_expert'
    end
  end

  def expert
    @expert ||= User.create valid_params
  end

  def seeker
    @seeker ||= User.create valid_params.merge(name: 'Seeker', email: 'seeker@consulted.co')
  end

  def offer
    @offer ||= expert.offers.create(group: group, rate: 300, experience: 20)
  end

  def group
    @group ||= Group.create name: 'Finance'
  end

  def deliveries
    ActionMailer::Base.deliveries
  end

  def call_params
    {
      length: 30,
      active_from: Time.now + 30.minutes,
      offer: offer,
      seeker: seeker,
      expert: expert
    }
  end
end
