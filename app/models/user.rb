class User
  include Mongoid::Document
  include Omniauthable::Lookups
  include Omniauthable::Linkedin

  extend Dragonfly::Model

  STATUS_LIST = %w(active disabled deactivated)

  field :profile_image_uid
  dragonfly_accessor :profile_image

  field :name, type: String, default: ''
  field :summary, type: String
  field :newsletter, type: Boolean
  field :languages, type: Array, default: ['english']
  field :timezone, type: String, default: 'Europe/Berlin'

  field :slug, type: String, default: -> { default_slug }

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

  validate :languages_allowed?
  validates_inclusion_of :timezone, in: ActiveSupport::TimeZone.zones_map(&:name)
  validates_inclusion_of :status, in: STATUS_LIST

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
  embeds_many :availabilities, class_name: 'User::Availability'

  validates_uniqueness_of :slug
  validates_with SlugValidator

  scope :experts, -> { where linkedin_network: { :$gte => User.required_connections } }
  scope :confirmed, -> { where confirmation_sent_at: { :$lte => Time.now } }
  scope :with_languages, -> languages { where languages: { :$all => languages } }
  scope :with_slug, -> slug { where slug: slug }

  accepts_nested_attributes_for :user_linkedin_connection, :companies, :educations, :offers, :availabilities

  def self.with_group(group)
    where(:'offers.group_id' => group.id)
  end

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
    current_company.position
  end

  def current_company
    companies.first
  end

  private

  def allowed_languages
    %W(spanish english mandarin german arabic)
  end

  def self.required_connections
    10
  end

  def default_slug
    slug = name.downcase.gsub ' ', '-'
    slug = email.downcase.split('@').first if slug == ''
    slug ||= ''
    i = 1
    while User.with_slug(slug).exists?
      slug += "#{i}"
      i += 1
    end
    slug
  end
end
