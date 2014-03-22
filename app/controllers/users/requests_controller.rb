class Users::RequestsController < Users::BaseController

  def review
    @expert  = User.experts.find_by slug: params[:slug]
    @offer   = @expert.offers.enabled.find params[:offer_id]
    @request = Request.new
  end

  def create
    result = RequestsAnExpert.for request_params.merge user: @user

    if result.failure?
      render :reviews, alert: result.message
    else
      redirect_to request_success_path(result[:request])
    end
  end

  def success
  end

  def cancel
    result = CancelsRequest.for user: @user, id: params[:id]
    if result.failure?
      return render json: { error: result.message }
    else
      @request = result.fetch :request
    end
  end

  def accept
  end

  def deline
  end

  private

  def request_params
    params.require(:request).permit :message, :offer, :expert, :length
  end
end
