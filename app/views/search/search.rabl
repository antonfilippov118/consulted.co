collection @offers
attributes :description, :rate, :experience
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
