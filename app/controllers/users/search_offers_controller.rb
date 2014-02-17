class Users::SearchOffersController < Devise::SessionsController
  include Authenticable

  before_filter :authenticate!

  respond_to :json

  def search
    unless current_user.confirmed?
      render json: {}, status: :unprocessable_entity
    end
  end
end
