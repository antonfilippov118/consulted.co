class Users::CallsController < Users::BaseController
  include CallsHelper
  def confirm
    result = AcceptsCall.for call_params[:call_id], @user
    if result.failure?
      render json: { error: result.message }, status: :bad_request
    else
      render json: { success: true }
    end
  end

  def index
    @calls = Call.future.for @user
  end

  def cancel
    result = CancelsCall.for call_params[:call_id], @user
    if result.failure?
      render json: { error: result.message }, status: :bad_request
    else
      render json: { success: true }
    end
  end

  private

  def call_params
    params.permit :call_id
  end
end
