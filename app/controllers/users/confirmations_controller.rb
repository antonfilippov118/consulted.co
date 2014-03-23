class Users::ConfirmationsController < Devise::ConfirmationsController
  # NOTE: maybe part of this code will be needed in future
  # respond_to :json

  # # resend confirmation
  # [:create, :new].each do |method|
  #   define_method method do
  #     head :method_not_allowed
  #   end
  # end

  # # confirm user
  # def show
  #   resource = User.confirm_by_token(params[:confirmation_token])

  #   if resource.errors.empty?
  #     redirect_to settings_path, notice: 'Your account was successfully confirmed!'
  #   else
  #     redirect_to root_path
  #   end
  # end

  def show
    @original_token = params[:confirmation_token]
    digested_token = Devise.token_generator.digest(self, :confirmation_token, params[:confirmation_token])
    self.resource = resource_class.find_by(confirmation_token: digested_token) if params[:confirmation_token].present?

    super if resource.nil? || resource.confirmed?
  end

  def update
    digested_token = Devise.token_generator.digest(self, :confirmation_token, params[resource_name][:confirmation_token])
    self.resource = resource_class.find_by(confirmation_token: digested_token) if params[resource_name][:confirmation_token].present?
    resource_attributes = params[resource_name].except(:confirmation_token).permit(:email, :name, :password, :password_confirmation)

    if resource.update_attributes(resource_attributes) && resource.password_match?
      resource.confirm!
      set_flash_message :notice, :confirmed
      sign_in_and_redirect(resource_name, resource)
    else
      render action: :show
    end
  end
end
