class Group
  include Mongoid::Document

  field :name, type: String
  field :description, type: String

  has_many :children, class_name: 'Group', inverse_of: :parent
  belongs_to :parent, class_name: 'Group', inverse_of: :children

  scope :roots, -> { where(parent_id: nil) }

  def as_json(opts)
    {
      id: id.to_s,
      name: name,
      description: description,
      children: children.map { |child| child.as_json(opts) }
    }
  end
end
