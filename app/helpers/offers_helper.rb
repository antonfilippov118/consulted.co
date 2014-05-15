module OffersHelper
  def offers_path_for(offer)
    "#{offers_path}/#{offer.url}/review"
  end

  def breadcrumbs(group)
    group.ancestors.sort_by(&:depth)
  end

  def possible_lengths
    @offer.lengths.map(&:to_i).sort
  end

  def maximum_call_time(offer)
    offer.expert.maximum_call_length offer
  end

  def next_call(offer)
    offer.expert.next_possible_call offer
  end
end
