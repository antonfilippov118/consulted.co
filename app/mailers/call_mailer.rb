class CallMailer < ApplicationMailer
  def seeker_confirmation(call)
    liquid_mail(:call_final_confirmation_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call)
  end

  def expert_confirmation(call)
    liquid_mail(:call_final_confirmation_to_expert, { to: call.expert.notification_email }, user: call.expert, call: call)
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
