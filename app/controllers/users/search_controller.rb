class Users::SearchController < Users::BaseController
  before_filter :authenticate_user!

  def show
  end

end
