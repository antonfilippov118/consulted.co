class Users::DashboardController < Users::BaseController

  def show
    @requests     = @user.requests.active
    @outstanding  = Request.active.by @user
    @calls        = @user.active_calls
    @upcoming     = @user.future_calls
  end

  def history

  end
end
