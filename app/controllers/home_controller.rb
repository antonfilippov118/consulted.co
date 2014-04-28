class HomeController < ApplicationController
  before_filter :logged_in?
  layout 'landing'
  def index
  end

  def logged_in?
    if user_signed_in?
      redirect_to overview_path
    end
  end
end
