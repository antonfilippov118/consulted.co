class ExpertController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound, with: :render404
  def page
    user = User.experts.with_slug slug
    @expert = user.first
    render404 if @expert.nil?
    title! "#{@expert.name} - Profile"
  end

  def render404
    fail ActionController::RoutingError, 'Not found'
  end

  private

  def slug
    params[:slug].downcase
  end
end
