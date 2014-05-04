class Investors::SessionsController < Devise::SessionsController
  skip_before_filter :authenticate!
  before_filter :live?
  layout 'investors'

  private

  def after_signin_path
    root_path
  end

  def live?
    if Settings.platform_live?
      redirect_to root_path
    end
  end
end
