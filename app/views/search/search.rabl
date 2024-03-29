collection :@offers
attributes :description, :rate, :experience, :url, :slug, :maximum_length, :likes
node :id do |offer|
  offer.id.to_s
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
    if user.companies.current
      user.companies.current.position
    else
      ""
    end
  end
  node :current_company do |user|
    if user.companies.current
      {
        name: user.companies.current.name,
        url: user.companies.current.url,
        city: user.companies.current.city
      }
    else
      false
    end
  end
  node :current_year do |user|
    if user.companies.current
      user.companies.current.from
    else
      ""
    end
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
