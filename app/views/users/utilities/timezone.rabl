object :@user
attributes :timezone
node :offset do |user|
  timezone.now.utc_offset
end
node :formatted_offset do |user|
  timezone.now.formatted_offset
end
