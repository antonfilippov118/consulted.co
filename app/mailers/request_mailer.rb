class RequestMailer < ActionMailer::Base
  default from: 'new-request@consulted.co'

  def expert_notification(call, message = nil)
    @call   = call
    @expert = call.expert
    @seeker = call.seeker
    mail(to: @expert.notification_email, subject: "#{@seeker.name} has requested a call")
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
    mail to: @expert.notification_email, subject: 'A call has been cancelled!'
  end
end
