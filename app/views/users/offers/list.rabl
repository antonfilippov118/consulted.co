collection @offers
attributes :description, :rate, :experience, :lengths, :name, :slug
child :group do
  attributes :description, :seeker_gain
end
