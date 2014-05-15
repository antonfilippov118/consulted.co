collection @calls
attributes :message, :pin, :length, :active?
node :id do |call|
  call.id.to_s
end
node :status do |call|
  call_status(call)
end
node :request_status do |call|
  request_status call
end
node :active_from do |call|
  start_time_for(call)
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
