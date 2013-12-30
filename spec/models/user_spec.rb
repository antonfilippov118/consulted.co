require "spec_helper"

describe User do
  context "create" do
    [:name, :email, :telephone].each do |sym|
      it "can be assigned a #{sym}" do
        u = User.new

        u.send "#{sym}=", "test"

        expect(u.send(sym)).to eql "test"
      end

      it "can be initialized with a user name" do
        params = {
          sym => "test"
        }
        u = User.new params

        expect(u.send(sym)).to eql "test"
      end
    end
  end

  context "validation" do
    it {
      should validate_presence_of :name
    }

    it {
      should validate_presence_of :email
    }

    it {
      should validate_uniqueness_of :email
    }
  end
end
