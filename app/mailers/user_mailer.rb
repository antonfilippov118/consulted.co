# encoding: utf-8

class UserMailer < ActionMailer::Base

  def confirmation(user)
    @user = user
    mail to: user.email, subject: 'Your consulted.co profile activation', from: 'registration@consulted.co'
  end
end
