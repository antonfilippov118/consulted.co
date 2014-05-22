class TimesController < ApplicationController
  def index
    if expert.nil?
      render json: []
    end
    result = FindsExpertTimes.for expert, duration
    if result.failure?
      render json: { error: result.message }
    end
    render json: result.fetch(:times)
  end

  private

  def expert
    User.experts.with_slug(params[:expert]).first
  end

  def duration
    return default_duration if params[:group].nil?
    group = Group.find params[:group]
    offer = expert.offers.with_group(group).first
    return default_duration if offer.nil?
    offer.minimum_length.minutes
  end

  def default_duration
    30.minutes
  end
end
