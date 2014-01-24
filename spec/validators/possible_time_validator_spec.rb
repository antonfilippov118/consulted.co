require File.dirname(__FILE__) + '/../spec_helper'

describe PossibleTimeValidator do
  let(:validator) { PossibleTimeValidator.new }

  before(:all) do
    User.delete_all
  end

  it 'should pass users without times scheduled' do
    expect(validator.validate confirmed_user).to be_true
  end

  it 'should fail unconfirmed users' do
    expect(validator.validate user).to be_false
  end

  context 'checking for maximum times' do
    let(:validator) { PossibleTimeValidator::CountValidator.new }

    it 'should fail users with too many times' do
      user = confirmed_user
      50.times do |number|
        user.possible_times << PossibleTime.new(length: 90)
      end

      expect(validator.validate user).to be_false
    end

    it 'should pass users with the maximum amount of times' do
      user = confirmed_user

      10.times do |number|
        user.possible_times << PossibleTime.new(length: 60)
      end

      expect(validator.validate user).to be_true
    end
  end

  def user
    User.new valid_params
  end

  def confirmed_user
    _user = user
    _user.confirm!
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
