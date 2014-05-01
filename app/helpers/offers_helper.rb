module OffersHelper
  def offers_path_for(offer)
    "#{offers_path}/#{offer.url}/review"
  end
end