class OffersController < ApplicationController
  def index
    @expert = User.experts.with_slug(params[:expert]).first
    if @expert.nil?
      render json: []
    end
    @offers = @expert.offers.enabled
  end

  def show
    @offer = Offer.find params[:id]
  end
end
