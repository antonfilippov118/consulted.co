class UserMailer < ActionMailer::Base

  def activation(user)
    mail to: user.email, subject: "Your consulted.co profile activation"
  end

end