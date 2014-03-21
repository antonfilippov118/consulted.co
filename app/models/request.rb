class Request
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :language, type: String
  field :length, type: Integer
  field :start, type: DateTime
  field :message, type: String
  field :offer_id

  delegate :group, to: :offer
  delegate :name, to: :offer

  def offer
    user.offers.find offer_id
  end
end
