class Users::SessionsController < Devise::SessionsController
  def create
    resource = warden.authenticate! auth_options.merge recall: "#{controller_path}#failure"
    result = sign_in resource_name, resource
    render json: { success: result }
  end

  def failure
    render json: { success: false }, status: 401
  end

  [:new].each do |method|
    define_method method do
      head :method_not_allowed
    end
  end
end
