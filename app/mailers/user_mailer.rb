class UserMailer < ActionMailer::Base

  def activation(user)
    mail to: user.email, subject: "Your consulted.co profile activation", from: "registration@consulted.co"
  end

end