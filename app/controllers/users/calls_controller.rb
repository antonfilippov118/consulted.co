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
    @reviewable = Call.can_be_reviewed.by @user
  end

  def cancel
    result = CancelsCall.for call_params[:call_id], @user
    if result.failure?
      render json: { error: result.message }, status: :bad_request
    else
      render json: { success: true }
    end
  end

  def review
    result = ReviewsCall.for call_params[:call_id], @user, review_params[:review]
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

  def review_params
    params.permit review: [:awesome, :understood_problem, :helped_solve_problem, :knowledgeable,
                           :value_for_money, :would_recommend, :feedback, :would_recommend_consulted]
  end
end
