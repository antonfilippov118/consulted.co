# encoding: utf-8

# User class
# base user class for all consulted.co customers
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
  field :active, type: Boolean, default: true

  field :access_token, type: String, default: proc { SecureRandom.urlsafe_base64 }

  validates_uniqueness_of :email
  validates_with EmailValidator

  def generate_new_token!
    self.access_token = loop do
      access_token = SecureRandom.urlsafe_base64(nil, false)
      break access_token unless self.class.where(access_token: access_token).exists?
    end
  end
end
