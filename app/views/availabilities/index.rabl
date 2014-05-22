collection @availabilities
node :id do |a|
  a.id.to_s
end
node :start do |a|
  a.starting.to_i * 1000
end
node :end do |a|
  a.ending.to_i * 1000
end

