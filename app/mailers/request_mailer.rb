class RequestMailer < ActionMailer::Base
  default from: 'new-request@consulted.co'

  def notification(request)
    @request = request
    @expert  = request.expert
    @seeker  = request.seeker
    mail(to: @expert.notification_email, subject: "#{@seeker.name} has requested a call")
  end

  def seeker_notification(request)
    @request = request
    @expert  = request.expert
    @seeker  = request.seeker
    mail(to: @expert.notification_email, subject: "You have requested a call with #{@expert.name}")
  end

  def cancellation(request)
    @request = request
    @expert  = request.expert
    mail to: @expert.notification_email, subject: 'A request has been cancelled!'
  end
end
