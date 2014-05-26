object @offer
attributes :name, :slug, :lengths, :maximum_length
child user: :expert do
  attributes :name, :slug
end
