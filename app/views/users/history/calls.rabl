collection @calls
attributes :name, :message, :status, :payment, :length, :active_from, :active

node :fee do |call|
  call.payment * Settings.platform_fee / 100
end

node :seeker do |call|
  seeker?(call)
end
node :expert do |call|
  expert? call
end
node :active do |call|
  call.active?
end
node :partner_name do |call|
  partner_for(call).name
end
node :id do |call|
  call.id.to_s
end
node :controllable do |call|
  [Call::Status::REQUESTED, Call::Status::ACTIVE].include? call.status
end
node :partner do |call|
  {
    profile_image_url: partner_for(call).profile_image.url,
    linkedin: partner_for(call).linkedin_url,
    twitter: partner_for(call).twitter_url
  }
end
child :group do
  attributes :slug
end
