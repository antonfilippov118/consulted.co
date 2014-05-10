class RequestMailer < ApplicationMailer

  def expert_notification(call, message = nil)
    liquid_mail(:call_requested_to_expert, { to: call.expert.notification_email }, call: call, user: call.expert)
  end

  def seeker_notification(call)
    liquid_mail(:call_requested_by_seeker, { to: call.seeker.notification_email }, call: call, user: call.seeker)
  end

  def cancellation(call)
    @call   = call
    @expert = call.expert
    liquid_mail(:request_cancellation, to: @expert.notification_email, subject: 'A call has been cancelled!')
  end
end
