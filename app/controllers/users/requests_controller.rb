class Users::RequestsController < Users::BaseController

  def review
    @expert  = User.experts.find_by slug: params[:slug]
    @offer   = @expert.offers.enabled.find params[:offer_id]
    @request = Request.new
  end

  def create
    result = RequestsAnExpert.for request_params.merge seeker: @user
    @request = result.fetch :request
    @offer   = result.fetch :offer
    @expert  = result.fetch :expert

    if result.failure?
      flash.now[:warning] = result.message
      render :review
    else
      redirect_to request_success_path(@request)
    end
  end

  def success
  end

  def cancel
    result = CancelsRequest.for params[:id], seeker: @user
    if result.failure?
      return render json: { error: result.message }
    else
      @request = result.fetch :request
    end
  end

  def accept
    result = AcceptsRequest.for params[:id]
    if result.failure?
      return render json: { error: result.message }
    else
      @request = result.fetch :request
      @calls   = @user.calls
      render json: { success: true }
    end
  end

  def deline
  end

  private

  def request_params
    params.require(:request).permit :message, :offer, :expert, :length, :start
  end
end
