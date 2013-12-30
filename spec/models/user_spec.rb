require "spec_helper"

class User
  include Mongoid::Document

  [:name, :email, :telephone].each do |_field|
    field _field, type: String
  end

  validates_presence_of :name
  validates_presence_of :email
end

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

  end
end
