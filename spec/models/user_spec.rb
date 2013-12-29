class User
  attr_accessor :name

  def initialize(args={})
    @name = args[:name]
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
  end
end
