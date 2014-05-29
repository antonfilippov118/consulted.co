class Users::AvailabilitiesController < Users::BaseController
  before_filter :require_expert!
  skip_before_filter :verify_authenticity_token

  def show
    @availabilities = Availability.for(@user).where starting: { :$gte => last_monday }
  end

  def update
    result = UpdatesOrCreatesAvailability.for @user, availability_params
    @availability = result.fetch :availability
    if result.failure?
      render json: { error: result.message }, status: :unprocessable_entity
    end
  end

  def destroy
    @availability = Availability.for(@user).find params[:id]
    unless @availability.destroy
      render json: { error: 'could not destroy availability' }, status: :unprocessable_entity
    end
  end

  private

  def availability_params
    params.require(:availability).permit :start, :end, :id, :recurring
  end

  def require_expert!
    unless @user.can_be_an_expert?
      render json: { message: 'Expert only route!' }, status: :unprocessable_entity
    end
  end

  def last_monday
    Time.now.beginning_of_week - 1.day
  end
end
