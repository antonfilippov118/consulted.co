require File.dirname(__FILE__) + '/../spec_helper'

describe PossibleTimeValidator do
  let(:validator) { PossibleTimeValidator.new }

  before(:each) do
    User.delete_all
  end

  after(:all) do
    User.delete_all
  end

  context 'checking user' do
    let(:validator) { PossibleTimeValidator::ExpertValidator }

    it 'should not pass times without a confirmed user' do
      time = PossibleTime.new(length: 90, user: user)
      expect(validator.validate time).to be_false
    end

    it 'should not pass users who cannot be experts' do
      time = PossibleTime.new length: 90, user: confirmed_user
      expect(validator.validate time).to be_false
    end

    it 'should pass users who are experts' do
      time = PossibleTime.new length: 120, user: expert_user
      expect(validator.validate time).to be_true
    end
  end

  context 'checking for maximum times in one week' do
    let(:validator) { PossibleTimeValidator::CountValidator }

    before(:each) do
      PossibleTime.delete_all

      15.times do # 1350 Minutes total on day 0
        PossibleTime.create(length: 90, user: expert_user)
      end
    end

    context 'day based checks' do

      it 'should check against the maximum minutes of a day' do
        time = PossibleTime.new length: 120, user: expert_user

        expect(validator.validate time).to be_false
      end

      it 'should allow times up to the maximum' do
        time = PossibleTime.new length: 60, user: expert_user
        expect(validator.validate time).to be_true

        time = PossibleTime.new length: 90, user: expert_user
        expect(validator.validate time).to be_true
      end
    end

    it 'should repsect the maximum of times that can be created in a week' do
      29.times do
        PossibleTime.create length: 30, user: expert_user
      end

      time = PossibleTime.new length: 30, user: expert_user
      expect(validator.validate time).to be_false
    end
  end

  def user
    User.new valid_params
  end

  def confirmed_user
    if @user.nil?
      _user = user
      _user.save
      _user.confirm!
      return @user = _user
    end
    @user
  end

  def expert_user
    _user = confirmed_user
    _user.linkedin_network = 100
    _user
  end

  def valid_params
    {
      name: 'florian',
      password: 'tester',
      password_confirmation: 'tester',
      confirmation_sent_at: Time.now,
      email: 'florian@consulted.co'
    }
  end
end
