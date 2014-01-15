class Users::SessionsController < Devise::SessionsController
  def create
    resource = warden.authenticate! auth_options.merge recall: "#{controller_path}#failure"
    result = sign_in resource_name, resource
    render json: { success: result }
  end

  def failure
    render json: { success: false }, status: 400
  end

  [:new].each do |method|
    define_method method do
      if current_user
        redirect_to '/#!/profile'
      else
        redirect_to '/#!/login'
      end
    end
  end
end
