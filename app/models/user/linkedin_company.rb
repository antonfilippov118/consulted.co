class User::LinkedinCompany
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user
  embeds_many :addresses, class_name: 'User::LinkedinCompany::Address'

  field :linkedin_id
  field :industry
  field :name
  field :from, type: Integer
  field :to, type: Integer, default: 0
  field :current, type: Boolean
  field :position, type: String
  field :url

  [:city, :postal_code, :fax, :phone, :street].each do |sym|
    delegate sym, to: :current_address
  end

  def self.current
    where(current: true).first
  end

  def current_address
    addresses.first || User::LinkedinCompany::Address.new
  end
end
