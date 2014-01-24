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
        time.user = User.create name: 'Florian'
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
        PossibleTime.new.week_number = 0
      end
    end
  end

  context 'validation' do
    it 'should only allow specific lengths' do
      time = PossibleTime.new
      time.length = 90

      time.user = User.create name: 'Florian'
      expect(time.valid?).to be_true

      time = PossibleTime.new
      time.user = User.create name: 'Florian'
      time.length = 117

      expect(time.valid?).to be_false
    end

    it 'should need a user' do
      time = PossibleTime.new
      time.length = 30
      expect(time.valid?).to be_false
    end
  end
end
