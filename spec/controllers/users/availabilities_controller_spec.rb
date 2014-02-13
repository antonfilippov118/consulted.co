require File.dirname(__FILE__) + '/../../spec_helper'

describe Users::AvailabilitiesController do

  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
    User.delete_all
    Availability.delete_all
  end

  describe 'GET #show' do
    context 'for no user' do
      it 'should not show the availabities without a logged in user' do
        get :show
        expect(response.success?).to be_false
        expect(response.status).to eql(401)
      end
    end

    context 'for non expert user' do
      it 'should not show any availabities' do
        user = User.create valid_params
        user.confirm!
        sign_in user

        get :show

        expect(response.success?).to be_false
        expect(response.status).to eql(422)
      end
    end

    context 'for expert user' do

      let :user do
        user = User.create valid_params
        user.linkedin_network = 10_000
        user.confirm!
        user
      end

      it 'should be able to filter the availabities by week' do
        sign_in user
        create_availability user: user

        get :show
        expect(response.success?).to be_true
        expect(response.status).to eql 200
      end

      it 'should use a param for filtering by week' do
        sign_in user
        current_week = DateTime.now.cweek

        get :show, week: current_week
        expect(response.success?).to be_true
        expect(response.status).to eql(200)
      end

      it 'includes recurring availabilites' do
        sign_in user
        current_week = DateTime.now.cweek
        current_day  = DateTime.now.cwday

        availability = create_availability user: user, recurring: true
        availability.save!

        get :show, week: current_week
        expect(response.success?).to be_true
        body = JSON.parse response.body
        expect(body[current_day - 1].length).to eql 1

        get :show, week: current_week + 1
        expect(response.success?).to be_true
        body = JSON.parse response.body

        expect(body[current_day - 1].length).to eql 1

      end
    end
  end

  context 'PUT #update' do
    context 'for non expert user' do

      it 'should fail without a user' do
        put :update, {}

        expect(response.success?).to be_false
        expect(response.status).to eql(401)
      end

      it 'should fail for non confirmed user' do
        user = User.create valid_params
        user.linkedin_network = 10_000_000_0

        sign_in user

        put :update, {}
        expect(response.status).to eql(422)
        expect(response.success?).to be_false
      end

      it 'should fail for user without enough linkedin contacts' do
        user = User.create valid_params
        user.confirm!
        sign_in user

        put :update, {}
        expect(response.status).to eql(422)
        expect(response.success?).to be_false
      end
    end

    context 'for expert user' do
      it 'should create an availability when it is new' do
        user = User.create valid_params
        user.linkedin_network = 10_000_000
        user.confirm!

        sign_in user

        params = {
          id: '09027078-a7fe9b19',
          new_event: true,
          ends: '2014-02-14T09:30:59.106Z',
          starts: '2014-02-14T09:00:59.106Z'
        }
        put :update, params

        expect(response.success?).to be_true
        expect(response.status).to eql(200)

        availabilities = Availability.for user
        expect(availabilities.length).to eql(1)
      end

      it 'should update an existing availability' do
        user = User.create valid_params
        user.linkedin_network = 10_000_000
        user.confirm!

        sign_in user

        availability = create_availability user: user, recurring: false
        availability.save!

        params = {
          id: availability.id,
          recurring: true,
          ends: '2014-02-14T09:30:59.106Z',
          starts: '2014-02-14T09:00:59.106Z'
        }

        put :update, params

        expect(response.success?).to be_true
        expect(response.status).to eql(200)

        availability = Availability.for(user).first

        expect(availability.recurring).to be_true
      end
    end
  end

  context 'DELETE #destroy' do
    it 'should not be accessible by conventional means' do
      availability = create_availability user: User.create(valid_params)
      delete :destroy, id: availability.id.to_s

      expect(response.success?).to be_false
      expect(response.status).to eql(401)
    end

    it 'should remove a created Availability' do
      user = User.create valid_params
      user.linkedin_network = 10_000
      user.confirm!
      sign_in user

      availability = create_availability user: user
      availability.save!

      delete :destroy, id: availability.id.to_s

      expect(response.success?).to be_true
      expect(response.status).to eql(200)
    end
  end

  def create_availability(opts = {})
    defaults = {
      starts: DateTime.now,
      ends: DateTime.now + 2.hours
    }
    opts = defaults.merge opts
    Availability.new opts
  end
end
