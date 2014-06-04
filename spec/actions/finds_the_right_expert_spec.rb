require 'spec_helper'

class FindsTheRightExpert
  include LightService::Organizer

  def self.for(params)
    offer, user = [:offer, :user].map { |sym| params.fetch sym }
    with(offer: offer, user: user).reduce [
      FindGroup,
      SendNotification
    ]
  end

  class FindGroup
    include LightService::Action

    executed do |context|
      slug = context.fetch :offer
      context[:group] = Group.find slug
    end
  end

  class SendNotification
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      group = context.fetch :group
      begin
        mailer.find_expert_request(group, user).deliver!
      rescue => e
        context.fail! e.message
      end
    end

    def self.mailer
      ContactMailer
    end
  end
end

describe FindsTheRightExpert do
  let(:action) { FindsTheRightExpert }

  before(:each) do
    deliveries.clear
  end

  it 'should send an email to support@consulted.co' do
    user = User.create valid_params
    group = Group.create name: 'Finance'
    result = action.for offer: group.slug, user: user
    expect(result.success?).to be_true

    mail = deliveries.last
    expect(mail.to).to eql %w(support@consulted.co)
  end

  def deliveries
    ActionMailer::Base.deliveries
  end
end
