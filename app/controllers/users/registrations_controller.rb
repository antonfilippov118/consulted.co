class Users::RegistrationsController < Devise::RegistrationsController
  # this controller only handles registration
  skip_before_filter :authenticate_scope!

  def create
    build_resource sign_up_params
    if resource.save
      render json: resource, status: 201
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  def cancel
    head :method_not_allowed
  end

  def edit
    head :method_not_allowed
  end

  def new
    head :method_not_allowed
  end

  def destroy
    head :method_not_allowed
  end

end
