class Users::OffersController < Users::BaseController
  def show
    title! 'Offer your time'
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

  def activate
    result = TogglesUserExpert.for @user
    if result.failure?
      flash[:notice] = result.message
    end
    redirect_to offers_path
  end

  def book
  end

  def review
    @offer   = Offer.find_by url: params[:offer_id]
    @expert  = @offer.expert
    @request = Request.new
    title! "#{@offer.name} by #{@offer.expert.name}"
  end

  private

  def offer_params
    params.permit :description, :experience, :rate, :enabled, :slug, lengths: [], group: [:id]
  end
end
