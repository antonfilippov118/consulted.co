class Users::SessionsController < Devise::SessionsController
  private

  def after_sign_in_path_for(resource)
    determined_path resource
  end

  def after_sign_out_path_for(resource)
    root_path
  end

end
