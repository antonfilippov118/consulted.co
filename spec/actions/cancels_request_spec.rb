require 'spec_helper'

describe CancelsRequest do
  before(:each) do
    Request.delete_all
    User.delete_all
    Group.delete_all
  end

  let :expert do
    User.create valid_params.merge email: 'florian1@consulted.co'
  end

  let :user do
    User.create valid_params
  end

  let :group do
    create :group
  end

  it 'should cancel a pending request to an expert' do
    setup

    result = CancelsRequest.for Request.first.id, seeker: user
    expect(result.success?).to be_true
    request = Request.first
    expect(request.cancelled?).to be_true
  end

  it 'should only be cancellable by the user who made the request' do
    setup
    other_user = User.create email: 'florian2@consulted.co'
    result = CancelsRequest.for Request.first, seeker: other_user

    expect(result.failure?).to be_true
  end

  it 'should send a notification to the expert' do
    setup

    ActionMailer::Base.deliveries = []

    CancelsRequest.for Request.first, seeker: user
    mails = ActionMailer::Base.deliveries
    expect(mails.last).not_to be_nil
    expect(mails.last.to).to eql [expert.email]
  end

  def setup
    expert.offers.create group: group, description: 'foo', rate: 30, experience: 20
    RequestsAnExpert.for offer: expert.offers.first, seeker: user, expert: expert, message: 'hello', length: 30, start: Time.now
  end
end