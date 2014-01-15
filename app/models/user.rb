class User
  include Mongoid::Document
  include Omniauthable::Lookups

  field :name, type: String
  field :newsletter, type: Boolean

  #
  # Devise
  #
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :trackable, :validatable, :confirmable

  ## Database authenticatable
  field :email,              type: String, default: ''
  field :encrypted_password, type: String, default: ''

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Linkedin
  field :provider
  field :uid
  field :linkedin_contacts, type: Integer, default: 0

  embeds_one :user_linkedin_connection, class_name: 'User::LinkedinConnection'

  def connect_to_linkedin(auth)
    self.provider = auth.provider
    self.uid = auth.uid
    self.user_linkedin_connection = User::LinkedinConnection.new(token: auth['extra']['access_token'].token, secret: auth['extra']['access_token'].secret)

    unless save
      return false
    end
    true
  end

  def disconnect_from_linkedin!
    self.provider = nil
    self.uid = nil
    self.user_linkedin_connection = nil
    save!
  end
end
