module GroupsHelper
  def offer(expert)
    expert.offers.with_group(@group).first
  end
end
