class User::LinkedinCompany
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user

  field :linkedin_id
  field :industry
  field :name
  field :from, type: Integer
  field :to, type: Integer, default: 0
  field :current, type: Boolean
  field :position, type: String

  def self.current
    where(current: true).first
  end
end
