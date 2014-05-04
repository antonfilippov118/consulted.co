class Investors::SessionsController < Devise::SessionsController
  skip_before_filter :authenticate!
  private

  def after_signin_path
    root_path
  end
end
