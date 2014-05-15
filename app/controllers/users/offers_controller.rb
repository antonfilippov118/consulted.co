class Users::OffersController < Users::BaseController
  before_filter :user_is_expert?, only: [:review]
  before_filter :date?, only: [:review]
  before_filter :blocks_available?, only: [:review]
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
    @request = Call.new
    title! "#{@offer.name} with #{@offer.expert.name}"
  end

  def create
    result = RequestsAnExpert.for request_params.merge seeker: @user
    if result.failure?
      flash[:warning] = result.message
      @offer = result.fetch :offer
      @expert = result.fetch :expert
      render :review
    else
      redirect_to success_requests_path
    end
  end

  private

  def offer_params
    params.permit :description, :experience, :rate, :enabled, :slug, lengths: [], group: [:id]
  end

  def request_params
    params.require(:call).permit :message, :offer, :expert, :length, :start, :active_from
  end

  def user_is_expert?
    @offer   = Offer.find_by url: params[:offer_id]
    @expert  = @offer.expert
    if @expert == @user
      redirect_to group_path(@offer.group)
    end
  end

  def date?
    date = params[:date]
    redirect_to root_path if date.nil?
    @dates = [date]
  end

  def blocks_available?
    time = @expert.next_possible_call @offer, @dates
    if time == false
      flash[:alert] = 'The expert is no longer available!'
      redirect_to root_url
    end
  end
end
