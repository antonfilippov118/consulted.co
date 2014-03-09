require File.dirname(__FILE__) + '/../spec_helper'

describe UpdatesOrCreatesAvailability do
  before(:each) do
    User.delete_all
  end

  context 'creating a new availability' do
    it 'should use the params' do
      u = user
      result = UpdatesOrCreatesAvailability.for u, availability_params

      expect(result.success?).to be_true
      expect(u.availabilities.count).to eql 1
      availability =  u.availabilities.first

      expect(availability.starts.strftime('%d.%m.%Y')).to eql('14.02.2014')
      expect(availability.ends.strftime('%d.%m.%Y')).to eql('14.02.2014')
    end

    it 'should update an existing availability' do
      u = user
      opts = {
        starts: Time.now,
        ends: Time.now + 30.minutes
      }

      availability        = u.availabilities.create opts
      params              = availability_params
      params[:id]         = availability.id
      params[:new_event]  = false

      result = UpdatesOrCreatesAvailability.for u, params
      expect(result.success?).to be_true
      expect(u.availabilities.count).to eql(1)

      expect(u.availabilities.first.starts.strftime('%d.%m.%Y')).to eql('14.02.2014')
      expect(u.availabilities.first.ends.strftime('%d.%m.%Y')).to eql('14.02.2014')
    end

    def availability_params
      {
        id: '09027078-a7fe9b19',
        new_event: true,
        ends: '2014-02-14T09:30:59.106Z',
        starts: '2014-02-14T09:00:59.106Z'
      }
    end

    def user
      _user = User.create valid_params
      _user.linkedin_network = 10_000
      _user.confirm!
      _user
    end
  end
end
