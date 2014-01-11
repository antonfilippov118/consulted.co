class Users::ProfileController < ApplicationController

  def profile
    render json: { email: 'florian@consulted.co', name: 'Florian' }
  end

end
