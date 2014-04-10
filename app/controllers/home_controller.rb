class HomeController < ApplicationController
  layout 'landing'
  def index
    @experts = User.experts.random(3)
  end
end
