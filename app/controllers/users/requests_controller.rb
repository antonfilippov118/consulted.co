class Users::RequestsController < Users::BaseController

  def create
    result = RequestsAnExpert.for request_params.merge seeker: @user
    if result.failure?
      flash[:warning] = result.message
      redirect_back
    else
      redirect_to success_requests_path
    end
  end

  def show
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
      @request  = result.fetch :request
      @upcoming = @user.future_calls
      @calls    = @user.active_calls
    end
  end

  def deline
  end

  private

  def request_params
    params.require(:request).permit :message, :offer, :expert, :length, :start
  end
end
