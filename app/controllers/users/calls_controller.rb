class Users::CallsController < Users::BaseController
  include CallsHelper
  def confirm
    result = AcceptsCall.for call_params[:call_id], @user
    if result.failure?
      render json: { error: result.message }
    else
      upcoming_calls
    end
  end

  def cancel
    result = CancelsCall.for call_params[:call_id], @user
    if result.failure?
      render json: { error: result.message }
    else
      upcoming_calls
    end
  end

  private

  def call_params
    params.permit :call_id
  end
end