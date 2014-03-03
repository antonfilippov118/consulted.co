class User
  include Mongoid::Document
  include Omniauthable::Lookups
  include Omniauthable::Linkedin

  extend Dragonfly::Model

  field :profile_image_uid
  dragonfly_accessor :profile_image

  field :name, type: String
  field :summary, type: String
  field :newsletter, type: Boolean
  field :languages, type: Array, default: ['english']
  field :positions, type: Array, default: []
  field :slug, type: String
  field :timezone, type: String, default: 'Europe/Berlin'

  field :providers, type: Array

  ## Linkedin
  field :uid
  field :linkedin_network, type: Integer, default: 0

  # notifications
  field :meeting_notification, type: Boolean, default: true
  field :notification_time, type: Integer, default: 15
  field :break, type: Boolean, default: true
  field :break_time, type: Integer, default: 15

  has_many :availabilities

  validate :languages_allowed?
  validates_inclusion_of :timezone, in: ActiveSupport::TimeZone.zones_map(&:name)

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
  embeds_many :offers, class_name: 'User::Offer'

  scope :experts, -> { where linkedin_network: { :$gte => User.required_connections } }
  scope :confirmed, -> { where confirmation_sent_at: { :$lte => Time.now } }
  scope :with_languages, -> languages { where languages: { :$all => languages } }
#  scope :with_group, -> group { "offers.group_id" => group.id }

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
    providers.include? 'linkedin'
  end

  def languages_allowed?
    languages.each do |language|
      unless allowed_languages.include? language
        errors.add :base, "Language '#{language}'' is not allowed."
      end
    end
    if languages.length > allowed_languages.length
      errors.add :base, 'Too many languages!'
    end
  end

  def current_position
    positions.first
  end

  def current_company
    companies.first
  end

  private

  def allowed_languages
    %W(spanish english mandarin german arabic)
  end

  def self.required_connections
    1
  end

end
