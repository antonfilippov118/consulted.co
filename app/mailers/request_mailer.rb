class RequestMailer < ActionMailer::Base
  default from: 'new-request@consulted.co'

  def notification(request)
    @request = request
    @expert  = request.expert
    mail(to: @expert.email, subject: 'You have a new request for a call!')
  end

  def cancellation(request)
    @request = request
    @expert  = request.expert

    mail to: @expert.email, subject: 'A request has been cancelled!'

  end
end
