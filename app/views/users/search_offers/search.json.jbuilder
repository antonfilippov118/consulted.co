json.array! @offers do |offer|
  json.description offer.description
  json.name offer.group.name
  json.experience offer.experience
  json.rate offer.rate

  json.expert do
    json.name offer.user.name
    json.background []
    json.education []
  end
end
