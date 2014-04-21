class ExpertController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound, with: :render404
  def page
    user = User.experts.with_slug params[:slug].downcase
    @expert = user.first
    title! "#{@expert.name} - Profile"
  end

  def render404
    fail ActionController::RoutingError, 'Not found'
  end
end
