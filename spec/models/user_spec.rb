class User
  attr_accessor :name, :email

  def initialize(args={})
    @name  = args[:name]
    @email = args[:email]
  end
end

describe User do
  context "create" do
    [:name, :email].each do |sym|
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
end
