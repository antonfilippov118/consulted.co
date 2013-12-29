class User
  attr_accessor :name
end

describe User do
  context "create" do
    it "can be assigned a name" do
      u = User.new
      u.name = "Florian"

      expect(u.name).to eql "Florian"
    end
  end
end
