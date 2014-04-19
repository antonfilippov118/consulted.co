attributes :id, :name, :description, :slug, :depth
child :children => :children do
  extends 'groups/child'
end