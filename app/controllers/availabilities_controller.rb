class AvailabilitiesController < ApplicationController
  def index
    @expert = User.experts.with_slug(params[:expert]).first
    if @expert.nil?
      render json: []
    end
  end
end
