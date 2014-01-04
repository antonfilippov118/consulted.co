require "spec_helper"

describe EmailValidator do

  let :validator do
    EmailValidator.new
  end

  it "passes users with a valid email" do
    user = user_with_valid_email
    validator.validate user

    expect(user.errors).to be_empty
  end

  it "adds an error for a user with an invalid email address" do
    user = user_with_invalid_email
    validator.validate user

    expect(user.errors).not_to be_empty
  end

  it "adds an error for empty emails" do
    user = user_with_empty_email
    validator.validate user

    expect(user.errors).not_to be_empty
  end

  it "adds an error for malformed emails" do
    user = user_with_malformed_email
    validator.validate user

    expect(user.errors).not_to be_empty
  end

  def user_with_valid_email
    User.new email: "florian@consulted.co"
  end

  def user_with_invalid_email
    User.new email: "florian@"
  end

  def user_with_empty_email
    User.new
  end

  def user_with_malformed_email
    User.new email: "florian@.co"
  end
end