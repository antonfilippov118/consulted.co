class User
  include Mongoid::Document
  include Omniauthable::Lookups
  include Omniauthable::Linkedin
  include Omniauthable::Twitter
  include Validatable::User
  include Sluggable::User
  include Scopable::User
  include Indexable::User
  include Liquidatable::User
  include Tokenable::User
  include Geo::Continent
  include Available

  extend Dragonfly::Model

  field :profile_image_uid

  dragonfly_accessor :profile_image do
    default [Rails.root, 'app/assets/images/anon.png'].join '/'
  end

  field :name, type: String, default: ''
  field :first_name
  field :last_name
  field :summary, type: String
  field :newsletter, type: Boolean
  field :languages, type: Array, default: ['english']
  field :timezone, type: String, default: 'Europe/Berlin'
  field :contact_email, type: String
  field :twitter_handle, type: String
  field :providers, type: Array

  # determines wheter or not the user wants to be an expert
  field :wants_to_be_an_expert, type: Boolean, default: false

  # temp field for sotring possible call times
  attr_accessor :possible_times

  ## Linkedin
  field :uid
  field :linkedin_network, type: Integer, default: 0
  field :shares_summary, type: Boolean, default: true
  field :shares_education, type: Boolean, default: true
  field :shares_career, type: Boolean, default: true

  # notifications
  field :meeting_notification, type: Boolean, default: true
  field :notification_time, type: Integer, default: 15
  field :break, type: Integer, default: 15
  field :max_meetings_per_day, type: Integer, default: 0
  field :start_delay, type: Integer, default: 30

  field :status, type: String, default: STATUS_LIST.first
  field :signed_up_via, type: String, default: 'register'
  field :asked_contact_email, type: Boolean, default: false

  # optional address
  embeds_one :address, class_name: 'User::Address'
  field :auto_send_invoice, type: Boolean, default: false

  #
  # Favorites
  #
  embeds_many :favorites, class_name: 'User::Favorite'
  accepts_nested_attributes_for :favorites

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

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  embeds_one :user_linkedin_connection, class_name: 'User::LinkedinConnection'
  embeds_many :companies, class_name: 'User::LinkedinCompany'
  embeds_many :educations, class_name: 'User::LinkedinEducation'

  has_many :availabilities, dependent: :destroy
  has_many :calls, inverse_of: :expert, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :requests, inverse_of: :seeker, class_name: 'Call', dependent: :destroy

  accepts_nested_attributes_for :user_linkedin_connection, :companies, :educations, :offers, :availabilities, :favorites, :address

  def expert?
    can_be_an_expert? && wants_to_be_an_expert?
  end

  def can_be_an_expert?
    # TODO: Paypal
    return false unless confirmed?
    return false unless linkedin?
    linkedin_network >= User.required_connections
  end

  def past_companies
    companies.select { |c| c != companies.current }.compact
  end

  def can_be_a_seeker?
    # TODO: Paypal
    return false unless confirmed?
  end

  def notification_email
    contact_email.presence || email
  end

  def password_match?
    errors[:password] << 'can\'t be blank' if password.blank?
    errors[:password_confirmation] << 'can\'t be blank' if password_confirmation.blank?
    errors[:password_confirmation] << 'does not match password' if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  def be_an_expert!
    update_attribute :wants_to_be_an_expert, !wants_to_be_an_expert
  end

  private

  def self.required_connections
    Settings.required_network
  end
end
