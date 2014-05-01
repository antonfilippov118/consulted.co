collection @offers
attributes :description, :rate, :experience, :url
node :id do |offer|
  offer.id.to_s
end
child :expert => :expert do
  attributes :name
  node :image do |user|
    user.profile_image.url
  end
  node :profile_url do |user|
    "#{root_url}#{user.slug}"
  end
  child :companies => :companies do
    attribute :name, :position, :from
  end
end
