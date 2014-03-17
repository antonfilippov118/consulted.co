class Group
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Tree

  field :name, type: String
  slug :name
  field :description, type: String
  field :seeker_gain, type: String
  field :seeker_expectation, type: String
  field :expert_background, type: String
  field :length_gain, type: String

  validates_associated :parent, :children

  before_destroy :destroy_children
end
