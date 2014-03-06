class Users::OffersController < Users::BaseController
  skip_before_filter :verify_authenticity_token, only: :update
  include ExpertsHelper
  def show
  end

  def list
    respond_to do |format|
      format.json { @offers = @user.offers.enabled }
    end
  end

  def update
    result = UpdatesOrCreatesOffer.for @user, offer_params
    if result.success?
      @offers = @user.reload.offers.enabled
      render :list, format: :json
    else
      render json: { error: result.message }
    end
  end

  helper ExpertsHelper

  private

  def offer_params
    params.require(:offer).permit :description, :experience, :rate, :enabled, lengths: [], group: [:id]
  end
end
