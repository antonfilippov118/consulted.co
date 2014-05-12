class ExpertController < ApplicationController
  rescue_from Mongoid::Errors::DocumentNotFound, with: :render404
  def page
    user = User.experts.with_slug slug
    @expert = user.first
    return render404 if @expert.nil?
    title! "#{@expert.name} - Profile"
  end

  def render404
    redirect_to '/404'
  end

  private

  def slug
    params[:slug].downcase
  end
end
