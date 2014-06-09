collection :@offers
attributes :name, :rate, :experience, :description, :slug, :lengths, :likes
node :cost_average do |offer|
  offer.recent_awesome_calls_cost
end
child :group do
  attributes :description, :seeker_gain
end

