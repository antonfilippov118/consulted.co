class User::Request
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :offer

  field :language, type: String
  field :length, type: Integer
  field :start, type: DateTime
  field :message, type: String

  delegate :group, to: :offer
end
