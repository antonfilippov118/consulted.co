object @user
node(:timezone) do
  {
    value: ActiveSupport::TimeZone.new(@user.timezone).to_s,
    name: ActiveSupport::TimeZone.new(@user.timezone).name
  }
end

node(:offset) do
  ActiveSupport::TimeZone.new(@user.timezone).utc_offset / 3600
end
node :zones_available do
  ActiveSupport::TimeZone.all.map do |zone|
    {
      name: zone.name,
      value: zone.to_s
    }
  end
end
