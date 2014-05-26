object @user
attributes :timezone
node :offset do |user|
  timezone.now.utc_offset
end
