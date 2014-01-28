class Group
  include Mongoid::Document

  field :name, type: String

  has_many :children, class_name: 'Group', inverse_of: :parent
  belongs_to :parent, class_name: 'Group', inverse_of: :children

  scope :roots, -> { where(parent_id: nil) }

end
