collection @groups
attributes :id, :name, :description, :children
node(:link) { |group| url_for group }