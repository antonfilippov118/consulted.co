class User
  include Mongoid::Document
  include Omniauthable::Lookups
  include Omniauthable::Linkedin
  include Validatable::User
  include Sluggable::User
  include Scopable::User

  extend Dragonfly::Model

  field :profile_image_uid
  dragonfly_accessor :profile_image

  field :name, type: String, default: ''
  field :summary, type: String
  field :newsletter, type: Boolean
  field :languages, type: Array, default: ['english']
  field :timezone, type: String, default: 'Europe/Berlin'

  field :providers, type: Array

  ## Linkedin
  field :uid
  field :linkedin_network, type: Integer, default: 0

  # notifications
  field :meeting_notification, type: Boolean, default: true
  field :notification_time, type: Integer, default: 15
  field :break, type: Integer, default: 15
  field :max_meetings_per_day, type: Integer, default: 0
  field :start_delay, type: Integer, default: 0

  field :country
  field :status, type: String, default: STATUS_LIST.first

  #
  # Indizes
  #
  index({ email: 1, slug: 1 }, unique: true)

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

  embeds_one :user_linkedin_connection, class_name: 'User::LinkedinConnection'
  embeds_many :companies, class_name: 'User::LinkedinCompany'
  embeds_many :educations, class_name: 'User::LinkedinEducation'
  embeds_many :offers, class_name: 'User::Offer' do
    def find_by_id(id)
      where(id: id).first
    end
  end
  embeds_many :availabilities, class_name: 'User::Availability'

  has_many :requests, class_name: 'User::Request'

  accepts_nested_attributes_for :user_linkedin_connection, :companies, :educations, :offers, :availabilities

  # TODO: since Mongoid hasn't random, so far this simple method just works.
  # In future we can add custom mongoid finder module and method to mongoid
  # criteria.
  def self.random(count = 1)
    criteria.to_a.shuffle[0, count]
  end

  def can_be_an_expert?
    # TODO: Paypal
    return false unless confirmed?
    linkedin_network >= User.required_connections
  end

  def can_be_a_seeker?
    # TODO: Paypal
    return false unless confirmed?
  end

  def linkedin?
    return false if providers.nil?
    providers.include? 'linkedin'
  end

  def current_position
    current_company.position
  end

  def current_company
    companies.first
  end

  private

  def self.required_connections
    10
  end
end
