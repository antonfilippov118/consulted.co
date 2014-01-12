class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :json

  # resend confirmation
  [:create, :new].each do |method|
    define_method method do
      head :method_not_allowed
    end
  end

  # confirm user
  def show
    resource = User.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      render json: { success: true }
    else
      render json: { success: false }, status: 400
    end
  end
end
