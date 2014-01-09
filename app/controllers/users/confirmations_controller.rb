class Users::ConfirmationsController < Devise::ConfirmationsController
  # resend confirmation
  def create
    head :method_not_allowed
  end
end
