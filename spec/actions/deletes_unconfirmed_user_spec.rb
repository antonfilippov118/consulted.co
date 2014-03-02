require File.dirname(__FILE__) + '/../spec_helper'

describe DeletesUnconfirmedUser do

  before(:each) do
    User.delete_all
  end

  it 'deletes a user after a given amunt of time' do
    User.create valid_params.merge confirmation_sent_at: 3.days.ago
    User.create valid_params.merge confirmation_sent_at: 2.days.ago
    User.create valid_params.merge confirmation_sent_at: 10.hours.ago

    DeletesUnconfirmedUser.after 24.hours

    expect(User.count).to equal(1)
  end
end
