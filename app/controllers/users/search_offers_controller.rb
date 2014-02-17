class Users::SearchOffersController < Devise::SessionsController
  include Authenticable

  before_filter :authenticate!

  def search
    unless current_user.confirmed?
      return render json: {}, status: :unprocessable_entity
    end

    result = SearchServiceOffers.with_options search_params

    if result.failure?
      render json: { error: result.message }, status: :unprocessable_entity
    else
      @offers = result[:offers]
      render formats: [:json]
    end
  end

  private

  def search_params
    params[:search_offer]
  end
end
