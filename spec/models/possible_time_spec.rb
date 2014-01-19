require File.dirname(__FILE__) + '/../spec_helper'

describe PossibleTime do

  context 'creation' do
    it 'should belong to a user' do
      should belong_to(:user)
    end

    it 'has a length' do
      expect do
        PossibleTime.new.length = 120
      end.not_to raise_error
    end

    it 'has a weekday' do
      expect do
        PossibleTime.new.weekday = PossibleTime::Monday
      end.not_to raise_error
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

    it 'should check against other times' do

    end
  end

end
