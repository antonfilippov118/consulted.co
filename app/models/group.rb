class Group
  include Mongoid::Document
  include Mongoid::Slug

  field :name, type: String
  slug :name
  field :description, type: String

  has_many :children, class_name: 'Group', inverse_of: :parent
  belongs_to :parent, class_name: 'Group', inverse_of: :children

  scope :roots, -> { where(parent_id: nil) }
end
