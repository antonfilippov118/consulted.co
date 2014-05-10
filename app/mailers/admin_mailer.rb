# encoding: utf-8

class AdminMailer < ApplicationMailer
  include Devise::Mailers::Helpers

  default reply_to: 'support@consulted.co'

  def welcome(record)
    liquid_mail(:admin_welcome, { subject: 'Your are the new admin at consulted.co', from: 'registration@consulted.co' }, record)
  end
end
