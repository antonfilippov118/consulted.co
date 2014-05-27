object @offer
attributes :name, :slug, :lengths, :maximum_length, :rate
child user: :expert do
  attributes :name, :slug
end
