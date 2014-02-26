class User
  include Mongoid::Document
  include Omniauthable::Lookups
  include Omniauthable::Linkedin

  extend Dragonfly::Model

  field :profile_image_uid
  dragonfly_accessor :profile_image

  field :name, type: String
  field :newsletter, type: Boolean
  field :reminder_time, type: Integer
  field :languages, type: Array, default: ['english']
  field :positions, type: Array, default: []

  has_many :availabilities
  has_many :offers

  validate :languages_allowed?

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
  embeds_many :companies, class_name: 'User::LinkedinCompany'

  scope :experts, -> { where linkedin_network: { :$gte => User.required_connections } }
  scope :confirmed, -> { where confirmation_sent_at: { :$lte => Time.now } }
  scope :with_languages, -> languages { where languages: { :$all => languages } }

  def can_be_an_expert?
    return false unless confirmed?
    linkedin_network >= User.required_connections
  end

  def linkedin?
    provider == 'linkedin'
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

  private

  def allowed_languages
    %W(spanish english mandarin german arabic)
  end

  def self.required_connections
    1
  end

  def self.synchonize_linkedin(user_id)
    result = SynchronizeLinkedinProfile.for user_id
    result.success?
  end
end
