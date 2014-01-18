# encoding: utf-8

class UserMailer < ActionMailer::Base
  include Devise::Mailers::Helpers

  default from: 'system@consulted.co', reply_to: 'support@consulted.co'

  def confirmation_instructions(record, token, opts = {})
    @token = token
    devise_mail(record, :confirmation_instructions,  subject: 'Your consulted.co profile activation', from: 'registration@consulted.co')
  end
end
