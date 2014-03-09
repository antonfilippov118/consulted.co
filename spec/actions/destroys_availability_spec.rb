require File.dirname(__FILE__) + '/../spec_helper'

describe DestroysAvailability do
  before(:each) do
    User.delete_all
  end

  context 'for expert user' do
    it 'should be successful' do
      u = user
      availability = create_availability u
      result = DestroysAvailability.for(u, availability.id.to_s)
      expect(result.success?).to be_true
      expect(u.availabilities.count).to eql 0
    end

    def user
      _user = User.create valid_params
      _user.linkedin_network = 10_000
      _user.confirm!
      _user
    end

    def create_availability(user, opts = {})
      params = {
         starts: Time.now,
         ends: Time.now + 60.minutes
      }
      opts = params.merge opts
      user.availabilities.create opts
    end
  end
end
