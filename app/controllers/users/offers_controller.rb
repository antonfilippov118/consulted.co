class Users::OffersController < Devise::SessionsController
  include Authenticable
  before_filter :authenticate!

  def show
    render json: current_user.offers, status: 200
  end

  def update

  end

end
