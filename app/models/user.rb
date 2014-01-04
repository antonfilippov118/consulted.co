# encoding: utf-8

# User class
# base user class for all consulted.co customers
class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  has_secure_password

  [:name, :email, :telephone, :password_digest, :single_access_token].each do |_field|
    field _field, type: String
  end

  [:name, :email].each do |_field|
    validates_presence_of _field
  end

  field :confirmed, type: Boolean, default: false
  field :active, type: Boolean, default: true

  validates_uniqueness_of :email
  validates_with EmailValidator
end
