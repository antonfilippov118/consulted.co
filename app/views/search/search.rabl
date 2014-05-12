collection @offers
attributes :description, :rate, :experience, :url
node :id do |offer|
  offer.id.to_s
end
node :likes do |offer|
  0
end
child :expert => :expert do
  attributes :name, :slug
  node :image do |user|
    user.profile_image.url
  end
  node :profile_url do |user|
    "#{root_url}#{user.slug}"
  end
  node :current_position do |user|
    user.companies.current.position
  end
  node :current_year do |user|
    user.companies.current.from
  end
  child({ past_companies: :companies }, if: :shares_career?) do
    attribute :name, :position, :from, :to
  end
  node :bookmarked do |user|
    bookmarked? user
  end
  node :id do |user|
    user.id.to_s
  end
end
