class User
  include Mongoid::Document
  include Omniauthable::Lookups
  include Omniauthable::Linkedin

  field :name, type: String
  field :newsletter, type: Boolean
  field :reminder_time, type: Integer

  has_many :possible_times

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
  field :linkedin_network, type: Integer, default: 0

  embeds_one :user_linkedin_connection, class_name: 'User::LinkedinConnection'

  def can_be_an_expert?
    return false unless confirmed?
    linkedin_network >= 1
  end

  def linkedin?
    provider == 'linkedin'
  end
end
