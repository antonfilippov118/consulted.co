class Users::DashboardController < Users::BaseController

  def show
    @requests    = @user.requests
    @outstanding = Request.active.by @user
    @calls       = []
  end

  def history

  end
end
