require File.dirname(__FILE__) + '/../spec_helper'

describe PossibleTimeValidator do
  let(:validator) { PossibleTimeValidator.new }

  before(:all) do
    User.delete_all
  end

  it 'should pass users without times scheduled' do
    _user = user
    _user.confirm!
    expect(validator.validate _user).to be_true
  end

  it 'should fail unconfirmed users' do
    expect(validator.validate user).to be_false
  end

  context 'checking for maximum times' do
    let(:validator) { PossibleTimeValidator::CountValidator.new }

    it 'should fail users with too many times' do
      _user = user
      50.times do |number|
        _user.possible_times << PossibleTime.new(length: 90)
      end

      expect(validator.validate user).to be_false
    end
  end

  def user
    User.new valid_params
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
