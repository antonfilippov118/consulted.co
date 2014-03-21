class Users::DashboardController < Users::BaseController

  def show
    @requests = @user.requests
    @calls    = []
  end

  def history

  end
end
