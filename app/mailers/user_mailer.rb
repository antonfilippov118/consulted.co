class UserMailer < ActionMailer::Base

  def activation(user)
    mail subject: "Your consulted.co profile activation"
  end

end