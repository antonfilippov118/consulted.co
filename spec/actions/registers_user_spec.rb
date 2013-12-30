require "spec_helper"

class RegistersUser
  include LightService::Organizer
  def self.for_new(user)
    with(user: user).reduce [

    ]
  end
end

describe RegistersUser do
  it "should be successful if user is valid" do
    result = RegistersUser.for_new valid_user
    expect(result.success?).to be_true
  end

  def valid_user
    User.new name: "Florian", email: "florian@consulted.co", password: "tester"
  end
end
