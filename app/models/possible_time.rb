class PossibleTime
  include Mongoid::Document
  belongs_to :user

  field :length
end
