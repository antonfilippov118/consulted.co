class Users::OffersController < Devise::SessionsController
  include Authenticable
  before_filter :authenticate!

  def show
    render json: current_user.offers, status: 200
  end

  def update
    result = UpdatesOffers.for current_user, offer_params

    if result.success?
      render json: { success: true }
    else
      render json: { error: result.message }, status: result[:status]
    end
  end

  private

  def offer_params
    params.require(:offers)
  end
end
