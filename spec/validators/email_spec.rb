require "spec_helper"

module Validators
  class Email < ActiveModel::Validator
    def validate(record)
      if (regexp =~ record.email).nil?
        record.errors.add :email, "is not properly formatted!"
      end
    end

  private
    def regexp
      /.*/
    end
  end
end

describe Validators::Email do

  let :validator do
    Validators::Email.new
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

  def user_with_valid_email
    User.new email: "florian@consulted.co"
  end

  def user_with_invalid_email
    User.new email: "florian@"
  end

  def user_with_empty_email
    User.new
  end
end