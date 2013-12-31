require "spec_helper"

describe UserMailer do

  describe "activation" do
    user = User.new name: "Florian", email: "FlorianKraft@gmx.de"
    let(:mail) { UserMailer.activation user }

    {
      subject: "Your consulted.co profile activation",
      to: [user.email]
    }.each_pair do |field, value|
      it "should correctly set the value of #{field}" do
        expect(mail.send field).to eql value
      end
    end
  end

end
