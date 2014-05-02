module OffersHelper
  def offers_path_for(offer)
    "#{offers_path}/#{offer.url}/review"
  end

  def breadcrumbs(group)
    group.ancestors.sort_by(&:depth)
  end
end
