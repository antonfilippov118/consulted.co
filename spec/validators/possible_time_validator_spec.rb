require File.dirname(__FILE__) + '/../spec_helper'

describe PossibleTimeValidator do
  let(:validator) { PossibleTimeValidator.new }

  before(:all) do
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
  end

  def user
    User.new valid_params
  end

  def confirmed_user
    _user = user
    _user.save
    _user.confirm!
    _user
  end

  def expert_user
    _user = user
    _user.confirm!
    _user.linkedin_network = 10
    _user.save
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
