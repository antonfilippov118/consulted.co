class Group
  include Mongoid::Document

  field :name, type: String

  embeds_many :categories
end
