class Users::RegistrationsController < Devise::RegistrationsController
  # this controller only handles registration
  skip_before_filter :authenticate_scope!

  def create
    build_resource sign_up_params
    if resource.save
      sign_in resource
      render json: resource, status: 201
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  [:cancel, :edit, :destroy, :new].each do |action|
    define_method action do
      deny_method
    end
  end

  private

  def deny_method
    head :method_not_allowed
  end

end
