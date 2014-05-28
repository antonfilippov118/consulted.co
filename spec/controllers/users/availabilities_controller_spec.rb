require 'spec_helper'

describe Users::AvailabilitiesController do
  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
  it 'should create an availability for the user' do
    user = User.create valid_params
    user.linkedin_network = 10_000
    user.providers = %w(linkedin)
    user.confirm!
    user.save
    sign_in user

    put :update, availability: {
        start: Time.now.to_i,
        end: (Time.now + 1.hour).to_i
      }

    expect(response.success?).to be_true
    expect(user.availabilities.count).to eql 1
    range = (Time.now - 10.minutes)..(Time.now + 10.minutes)
    expect(range).to cover user.availabilities.first.starting
  end
end
