module GroupsHelper
  def offer(expert)
    expert.offers.with_group(@group).first
  end

  def past_companies(expert)
    expert.companies.drop 1
  end
end
