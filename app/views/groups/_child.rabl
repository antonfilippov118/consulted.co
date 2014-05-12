attributes :id, :name, :description, :slug, :depth, :prioritized
child :children => :children do
  extends 'groups/child'
end
