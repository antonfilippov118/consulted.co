class User
  include Mongoid::Document

  [:name, :email, :telephone].each do |_field|
    field _field, type: String
  end

  [:name, :email].each do |_field|
    validates_presence_of _field
  end

  validates_uniqueness_of :email
end
