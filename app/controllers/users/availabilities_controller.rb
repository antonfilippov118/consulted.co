class Users::AvailabilitiesController < Devise::SessionsController
  include Authenticable
  before_filter :authenticate!

  def show
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
