class ExpertController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound, with: :render404
  def page
    user = User.experts.find_by slug: params[:slug]
    unless user.can_be_an_expert?
      return render404
    end
    @expert = user
    title! "#{@expert.name} - Profile"
  end

  def render404
    fail ActionController::RoutingError, 'Not found'
  end
end
