require "spec_helper"

class RegistersUser
  include LightService::Organizer
  def self.for_new(user)
    with(user: user).reduce [
      ValidatesUserAction,
      SavesUserAction
    ]
  end

  class ValidatesUserAction
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      next context.set_failure! "User is invalid!" unless user.valid?
    end
  end

  class SavesUserAction
    include LightService::Action
    executed do |context|
      user = context.fetch :user
      begin
        user.save!
      rescue Exception => e
        next context.set_failure! e
      end
    end
  end
end

describe RegistersUser do
  before :each do
    user_class.delete_all
  end
  it "should be successful if user is valid" do
    result = RegistersUser.for_new valid_user
    expect(result.success?).to be_true
  end

  it "should be a failure with an invalid user data" do
    result = RegistersUser.for_new invalid_user
    expect(result.failure?).to be_true
  end

  it "should fail when a user does not give a correct email address" do
    user = user_class.new name: "Florian", email: "fdknflasf", password: "tester", password_confirmation: "tester"
    result = RegistersUser.for_new user
    expect(result.failure?).to be_true
  end

  it "should save the user to the db when successful" do
    user = valid_user
    result = RegistersUser.for_new user

    expect(result.success?).to be_true
    expect(user_class.count).to eql 1
  end

  it "should not save the user to the db when failed" do
    user = invalid_user
    result = RegistersUser.for_new user
    expect(result.failure?).to be_true
    expect(user_class.count).to eql 0
  end

  def valid_user
    user_class.new name: "Florian", email: "florian@consulted.co", password: "tester", password_confirmation: "tester"
  end

  def invalid_user
    [
      user_class.new(name: "Florian", password: "tester"),
      user_class.new(name: "Florian", password: "tester", password_confirmation: "tester1"),
      ].shuffle.first
  end


  def user_class
    User
  end
end
