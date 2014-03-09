object @user
node(:timezone) do
  {
    value: ActiveSupport::TimeZone.new(@user.timezone).to_s,
    name: ActiveSupport::TimeZone.new(@user.timezone).name
  }
end
node :zones_available do
  ActiveSupport::TimeZone.all.map do |zone|
    {
      name: zone.name,
      value: zone.to_s
    }
  end
end
