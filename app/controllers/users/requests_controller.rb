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

  private

  def request_params
    params.require(:call).permit :message, :offer, :expert, :length, :start
  end
end
