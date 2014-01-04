require "spec_helper"

describe UserMailer do

  describe "activation" do
    user = User.new name: "Florian", email: "FlorianKraft@gmx.de", single_access_token: "foo"
    let(:mail) { UserMailer.confirmation user }

    {
      subject: "Your consulted.co profile activation",
      to: [user.email],
      from: ["registration@consulted.co"]
    }.each_pair do |field, value|
      it "should correctly set the value of #{field}" do
        expect(mail.send field).to eql value
      end
    end

    it "should have the name of the user in the email" do
      expect(mail.body.encoded).to match user.name
    end

    it "should contain the users hash token for verification" do
      expect(mail.body.encoded).to match /confirm\/foo/
    end
  end

end
