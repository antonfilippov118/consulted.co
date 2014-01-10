class Users::UtilitiesController < ApplicationController
  def available
    available = !User.where(email: params[:email].downcase).exists?

    render json: { available: available }, status: available ? :ok : :bad_request
  end
end
