class Group
  include Mongoid::Document

  field :name, type: String

  has_many :children, class_name: 'Group', inverse_of: :parent
  belongs_to :parent, class_name: 'Group', inverse_of: :children

  scope :roots, -> { where(parent_id: nil) }

  def as_json(opts)
    {
      id: id.to_s,
      name: name,
      children: children.map { |child| child.as_json(opts) }
    }
  end
end
