# encoding: utf-8
if Rails.env.development?
  ActionMailer::Base.delivery_method = :sendmail
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.raise_delivery_errors = true
end
