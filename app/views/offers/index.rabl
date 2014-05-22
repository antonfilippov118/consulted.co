collection @expert.offers.enabled
attributes :name, :rate, :experience, :description, :slug, :lengths
node :likes do |offer|
  []
end
child :group do
  attributes :description, :seeker_gain
end

