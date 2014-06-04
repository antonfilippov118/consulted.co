require 'spec_helper'

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
