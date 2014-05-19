module OffersHelper
  def offers_path_for(offer)
    "#{offers_path}/#{offer.url}/review"
  end

  def breadcrumbs(group)
    group.ancestors.sort_by(&:depth)
  end

  def possible_lengths
    max = @offer.expert.maximum_call_length @offer
    @offer.lengths.map(&:to_i).reject { |time| time > max.to_i }.sort
  end

  def maximum_call_time(offer, dates = [])
    offer.expert.maximum_call_length offer, dates
  end

  def next_call(offer, dates = [])
    offer.expert.next_possible_call offer, dates
  end

  def call_time
    @offer.expert.next_possible_call @offer, @dates
  end
end
