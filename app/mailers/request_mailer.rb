class RequestMailer < ApplicationMailer

  def expert_notification(call, message = nil)
    date = Time.at(call.active_from).in_time_zone(call.expert.timezone).strftime format
    liquid_mail(:call_requested_to_expert, { to: call.expert.notification_email }, call: call, user: call.expert, date: date)
  end

  def seeker_notification(call)
    date = Time.at(call.active_from).in_time_zone(call.seeker.timezone).strftime format
    liquid_mail(:call_requested_by_seeker, { to: call.seeker.notification_email }, call: call, user: call.seeker, date: date)
  end

  def cancellation(call)
    @call   = call
    @expert = call.expert
    liquid_mail(:request_cancellation, to: @expert.notification_email, subject: 'A call has been cancelled!')
  end
end
