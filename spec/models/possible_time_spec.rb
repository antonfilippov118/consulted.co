require File.dirname(__FILE__) + '/../spec_helper'

describe PossibleTime do

  before(:all) do
    User.delete_all
  end

  context 'creation' do
    it 'should belong to a user' do
      should belong_to(:user)
    end

    it 'has a length' do
      expect do
        PossibleTime.new.length = 120
      end.not_to raise_error
    end

    %w{Monday Tuesday Wednesday Thursday Friday Saturday Sunday}.each_with_index do |day, index|
      it "allows #{day} as a value for a weekday" do
        time = PossibleTime.new
        time.weekday = index
        time.user = user
        time.length = 90
        expect(time.valid?).to be_true
      end
    end

    it 'should not allow any day outside the week' do
      time = PossibleTime.new
      time.user = User.create name: 'florian'
      time.length = 90
      time.weekday = 18
      expect(time.valid?).to be_false
    end

    it 'should have a week number' do
      expect do
        PossibleTime.new.week_of_year = 0
      end.not_to raise_error
    end

    it 'should only allow certain week numbers (0 - 53)' do
      time = PossibleTime.new length: 60, week_of_year: 700, user: User.new
      expect(time.valid?).to be_false
    end

    it 'should be able to be set as recurring' do
      expect do
        PossibleTime.new.recurring = true
      end.not_to raise_error
    end

    it 'should be able to have a start time' do
      expect do
        PossibleTime.new.starts = Time.now
      end.not_to raise_error
    end
  end

  context 'validation' do
    it 'should only allow specific lengths' do
      time = PossibleTime.new
      time.length = 90
      time.user = user

      expect(time.valid?).to be_true

      time = PossibleTime.new
      time.user = user
      time.length = 117

      expect(time.valid?).to be_false
    end

    it 'should need a user' do
      time = PossibleTime.new
      time.length = 30
      expect(time.valid?).to be_false
    end
  end

  def user
    _user = User.create name: 'Florian', confirmation_sent_at: Time.now, linkedin_network: 9001
    _user.confirm!
    _user
  end
end
