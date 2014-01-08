class Users::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource sign_up_params
    if resource.save
      render json: resource, status: 201
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end
end
