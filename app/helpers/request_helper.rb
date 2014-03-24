module RequestHelper
  def available_times(expert)
    availabilities = expert.availabilities.where starts: { :$gte => Time.now, :$lte => (Time.now + 3.weeks) }
    availabilities.map do |availability|
      [availability.starts.strftime('%Y-%m-%d %R'), availability.starts]
    end
  end
end
