# encoding: utf-8

class AdminMailer < ActionMailer::Base
  include Devise::Mailers::Helpers

  default from: 'system@consulted.co', reply_to: 'support@consulted.co'

  def welcome(record)
    devise_mail(record, :welcome,  subject: 'Your are the new admin at consulted.co', from: 'registration@consulted.co')
  end
end
