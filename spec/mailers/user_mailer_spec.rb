require "spec_helper"

describe UserMailer do
  describe "activation" do
    let(:user) { user_class.new name: "Florian", email: "FlorianKraft@gmx.de" }
    let(:mail) { UserMailer.activation user }

    it "renders the subject properly" do
      expect(mail.subject).to eql "Your consulted.co profile activation"
    end

    it "uses the user's email as an address" do
      expect(mail.to).to eql [user.email]
    end
  end

  def user_class
    User
  end
end
