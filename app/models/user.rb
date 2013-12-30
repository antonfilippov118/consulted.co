class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  has_secure_password

  [:name, :email, :telephone, :password_digest].each do |_field|
    field _field, type: String
  end

  [:name, :email].each do |_field|
    validates_presence_of _field
  end

  field :confirmed, type: Boolean, default: false

  validates_uniqueness_of :email
  validates_with EmailValidator
end
