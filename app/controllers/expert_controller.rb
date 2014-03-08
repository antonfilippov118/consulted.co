class ExpertController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound, with: :render404
  def page
    @expert = User.experts.find_by slug: params[:slug]
  end

  def render404
    fail ActionController::RoutingError, 'Not found'
  end
end
