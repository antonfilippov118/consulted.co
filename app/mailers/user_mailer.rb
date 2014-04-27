# encoding: utf-8

class UserMailer < ApplicationMailer
  include Devise::Mailers::Helpers

  default reply_to: 'support@consulted.co'

  def confirmation_instructions(record, token, opts = {})
    @token = token
    liquid_mail(:confirmation_instructions, { subject: 'Your consulted.co profile activation', from: 'registration@consulted.co' }, record)
  end

  def reset_password_instructions(record, token, opts = {})
    @token = token
    liquid_mail(:reset_password_instructions, opts, record)
  end
end
