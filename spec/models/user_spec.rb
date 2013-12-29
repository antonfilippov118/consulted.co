class User
  attr_accessor :name, :email

  def initialize(args={})
    @name  = args[:name]
    @email = args[:email]
  end
end

describe User do
  context "create" do
    it "can be assigned a name" do
      u = User.new
      u.name = "Florian"

      expect(u.name).to eql "Florian"
    end

    it "can be initialized with a user name" do
      u = User.new name: "Florian"

      expect(u.name).to eql "Florian"
    end

    it "can be assigned an email" do
      u = User.new
      u.email =  "florian@consulted.co"
      expect(u.email).to eql "florian@consulted.co"
    end

    it "can be initialized with an email" do
      u = User.new email: "florian@consulted.co"

      expect(u.name).to eql "florian@consulted.co"
    end
  end
end
