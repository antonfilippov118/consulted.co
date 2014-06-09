object false

child :@reviewable => :reviewable do
  attributes :length
  node :id do |call|
    call.id.to_s
  end
  child :group do
    attributes :name, :slug
  end
  node :status_name do |call|
    call_status(call)
  end
  node :timestamp do |call|
    call.active_from.to_i
  end
  node :partner_name do |call|
    partner_for(call).name
  end
end

child :@calls => :calls do
  attributes :message, :pin, :length, :status, :language
  child :group do
    attributes :name, :slug
  end
  node :active do |c|
    c.active?
  end
  node :id do |call|
    call.id.to_s
  end
  node :status_name do |call|
    call_status(call)
  end
  node :request_status do |call|
    request_status call
  end
  node :timestamp do |call|
    call.active_from.to_i
  end
  node :seeker do |call|
    seeker?(call)
  end
  node :expert do |call|
    expert?(call)
  end
  node :class do |call|
    call_class call
  end
  node :partner_name do |call|
    partner_for(call).name
  end
  node :controllable do |call|
    [Call::Status::REQUESTED, Call::Status::ACTIVE].include? call.status
  end
end
