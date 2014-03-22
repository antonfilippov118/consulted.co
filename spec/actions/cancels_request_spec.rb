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
    build :group
  end

  it 'should cancel a pending request to an expert' do
    setup

    result = CancelsRequest.for id: Request.first.id, user: user
    expect(result.success?).to be_true
    request = Request.first
    expect(request.cancelled?).to be_true
  end

  it 'should only be cancellable by the user who made the request' do
    setup
    other_user = User.create email: 'florian2@consulted.co'
    result = CancelsRequest.for id: Request.first, user: other_user

    expect(result.failure?).to be_true
  end

  def setup
    expert.offers.create group: group, description: 'foo', rate: 30, experience: 20
    RequestsAnExpert.for offer: expert.offers.first, user: user, expert: expert, message: 'hello', length: 30, start: Time.now
  end
end
