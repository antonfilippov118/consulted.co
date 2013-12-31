require "spec_helper"

describe UserMailer do
  describe "activation" do
    let(:user) { user_class.new name: "Florian", email: "FlorianKraft@gmx.de" }
    let(:mail) { UserMailer.activation user }
  end

  it "renders the subject properly" do
    binding.pry
    expect(mail.subject).to eql "Your consulted.co profile activation"
  end

  def user_class
    User
  end
end
