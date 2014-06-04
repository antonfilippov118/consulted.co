require 'spec_helper'

describe CallMailer do
  let(:mailer) { CallMailer }

  describe 'reminders' do
    it 'should compile with the variables n th subject field before sending' do
      template =  EmailTemplate.find_by name: 'call_reminder_to_seeker'
      template.update_attribute :subject, 'Foo: {{call.expert.name}}'
      call.confirm!
      mail = mailer.call_reminder_to_seeker call
      expect(mail.subject).to eql("Foo: #{call.expert.name}")
    end
  end

  def expert
    @expert ||= User.create valid_params
  end

  def expert
    @expert ||= User.create valid_params
  end

  def seeker
    @seeker ||= User.create valid_params.merge(name: 'Seeker', email: 'seeker@consulted.co')
  end

  def offer
    @offer ||= expert.offers.create(group: group, rate: 3030, experience: 20, lengths: %w(30 60))
  end

  def group
    @group ||= Group.create name: 'Finance'
  end

  def call
    c = Call.create call_params
    deliveries.clear
    c
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
