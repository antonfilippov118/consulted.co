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
      redirect_to settings_path, notice: 'Your account was successfully confirmed!'
    else
      redirect_to root_path
    end
  end
end
