class RequestMailer < ActionMailer::Base
  default from: 'new-request@consulted.co'

  def request_notification(options = {})
    @expert  = options.fetch :expert
    @request = options.fetch :request

    mail(to: @expert.email, subject: 'You have a new request for a call!')
  end
end
