attributes :id, :name, :description
node(:link) { |group| url_for group }
child :children => :children do
  extends 'groups/child'
end