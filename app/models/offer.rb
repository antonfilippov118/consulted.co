class Offer
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  belongs_to :group

  field :description, type: String
  field :experience, type: Integer

  [:experience, :description, :user_id, :category_id].each do |value|
    validates_presence_of value
  end

  validates_numericality_of :experience

  delegate :languages, to: :user
  delegate :availabilities, to: :user

  def available?
    availabilities.length > 0
  end

  def unavailable?
    availabilities.length == 0
  end
end
