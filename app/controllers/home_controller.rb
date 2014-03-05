class HomeController < ApplicationController
  def index
    @experts = User.experts.random(3)
  end
end
