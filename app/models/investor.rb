class Investor
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :trackable, :timeoutable

  field :email
  field :encrypted_password, type: String, default: ''

  field :note, type: String

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

   def timeout_in
     1.year
   end
end
