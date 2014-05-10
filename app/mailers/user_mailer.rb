# encoding: utf-8

class UserMailer < ApplicationMailer
  include Devise::Mailers::Helpers

  default reply_to: 'support@consulted.co'

  def confirmation_instructions(record, token, opts = {})
    variables = {
      user: record,
      confirmation_url: user_confirmation_url(confirmation_token: token)
    }
    liquid_mail(:signup_confirmation, opts, variables)
  end

  def reset_password_instructions(record, token, opts = {})
    variables = {
      user: record,
      reset_url: edit_user_password_url(reset_password_token: token)
    }
    liquid_mail(:reset_password_instructions, opts, variables)
  end
end
