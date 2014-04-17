attributes :id, :name, :description, :slug
child :children => :children do
  extends 'groups/child'
end