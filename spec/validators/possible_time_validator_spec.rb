require File.dirname(__FILE__) + '/../spec_helper'

describe PossibleTimeValidator do
  let(:validator) { PossibleTimeValidator.new }
  before(:all) do
    User.delete_all
  end

  it 'should pass users without times scheduled' do
    validator.validate user
    expect(user.valid?).to be_true
  end

  def user
    User.new name: 'florian', password: 'tester', password_confirmation: 'tester', confirmation_sent_at: Time.now
  end
end
