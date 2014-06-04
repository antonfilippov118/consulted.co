class Users::PasswordsController < Devise::PasswordsController
  def create
    super
    unless successfully_sent?(resource)
      flash[:warning] = 'This email address is unknown.'
    end
  end
end
