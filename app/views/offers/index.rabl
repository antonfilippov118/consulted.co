collection @expert.offers.enabled
attributes :name, :rate, :experience, :description, :slug
node :likes do |offer|
  []
end
child :group do
  attributes :description
end

