class ExpertController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound, with: :render404
  def page
    user = User.experts.find_by slug: slug
    @expert = user.first
    title! "#{@expert.name} - Profile"
  end

  def render404
    fail ActionController::RoutingError, 'Not found'
  end

  private

  def slug
    if params[:slug].nil?
      render404
    end
    params[:slug].downcase
  end
end
