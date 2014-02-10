class Users::AvailabilitiesController < Devise::SessionsController
  include Authenticable
  before_filter :authenticate!

  def show
    week = params[:week] || Date.now.strftime('%W')
    Availability.for(current_user).in_week(week)
  end

  def update
    result = UpdatesOrCreatesAvailability.for current_user, params

    if result.success?
      render json: result[:availability]
    else
      render json: { error: result.message }, status: :unprocessable_entity
    end
  end
end
