class Users::OffersController < Devise::SessionsController
  include Authenticable
  before_filter :authenticate!

  def show
    render json: current_user.offers, status: 200
  end

  def update
    result = UpdatesOffers.for current_user, params
    if result.success?
      render json: { success: true }
    else
      render json: { error: result }
    end
  end

end
