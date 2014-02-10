require File.dirname(__FILE__) + '/../../spec_helper'

describe Users::AvailabilitiesController do

  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
    User.delete_all
    Availability.delete_all
  end

  describe 'GET #show' do
    it 'should not show the availabities without a logged in user' do
      get :show
      expect(response.success?).to be_false
      expect(response.status).to eql(401)
    end

    it 'should be able to filter the availabities by week' do

      availability  = create_availability

      get :show
      expect(response.success?).to be_true
      expect(response.status).to eql 200

    end

    it 'should use a param for filtering by week' do
      current_week = Time.now.strftime('%W').to_i

      get :show, week: current_week
      expect(response.success?).to be_true
      expect(response.status).to eql(value)
    end

    it 'should deliver different availabilites based on week given' do
      current_week  = Time.now.strftime('%W').to_i
      availability  = create_availability

      second_opts = {
        starts: (Time.now + 1.week),
        ends: (Time.now + 1.week + 2.hours),
        user: user
      }
      second_availability = create_availability second_opts

      get :show, week: current_week
      expect(response.success?).to be_true
      expect(response.status).to eql(200)

      get :show, week: current_week + 1
      expect(response.success?).to be_true
      expect(response).to eql(200)

    end
  end

  def create_availability(opts = {})
    defaults = {
      starts: Time.now,
      ends: Time.now + 2.hours,
      user: user
    }
    opts = defaults.merge opts
    Availability.new opts
  end

  def user
    User.create valid_params
  end
end
