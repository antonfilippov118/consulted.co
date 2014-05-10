class RequestMailer < ActionMailer::Base
  default from: 'new-request@consulted.co'

  def expert_notification(call, message = nil)
    @call    = call
    @expert  = call.expert
    @seeker  = call.seeker
    @message = message
    liquid_mail(:expert_notification, to: @expert.notification_email, subject: "#{@seeker.name} has requested a call")
  end

  def seeker_notification(call)
    @call    = call
    @expert  = call.expert
    @seeker  = call.seeker
    mail(to: @seeker.notification_email, subject: "You have requested a call with #{@expert.name}")
  end

  def cancellation(call)
    @call   = call
    @expert = call.expert
    liquid_mail(:request_cancellation, to: @expert.notification_email, subject: 'A call has been cancelled!')
  end
end
