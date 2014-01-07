# encoding: utf-8

# User class
# base user class for all consulted.co customers
class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  devise :registerable

  [:name, :telephone, :email, :password]. each do |_field|
    field _field, type: String
  end

  attr_accessor :password_confirmation
end
