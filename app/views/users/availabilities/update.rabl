object :@availability
node :id do |availability|
  availability.id.to_s
end
node :start do |availability|
  availability.starting.to_i
end
node :end do |availability|
  availability.ending.to_i
end
