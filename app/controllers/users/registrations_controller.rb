class Users::RegistrationsController < Devise::RegistrationsController
  def after_sign_in_path_for(resource)
    overview_path
  end

  def after_sign_up_path_for(resource)
    binding.pry
  end
end
