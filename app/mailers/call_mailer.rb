class CallMailer < ActionMailer::Base
  def seeker_confirmation(call)
    @call   = call
    @seeker = call.seeker
    mail(to: @seeker.notification_email, subject: 'Your call request was confirmed!')
  end

  def expert_confirmation(call)
    @call   = call
    @expert = call.expert
    mail(to: @expert.notification_email, subject: 'You have confirmed a call!')
  end

  def seeker_cancellation(call)
    @call   = call
    @seeker = call.seeker
    mail(to: @seeker.notification_email, subject: 'Your call was cancelled!')
  end

  def expert_cancellation(call)
    @call   = call
    @expert = call.expert
    mail(to: @expert.notification_email, subject: 'Your have cancelled a call!')
  end
end