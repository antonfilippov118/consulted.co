class CallMailer < ApplicationMailer

  def seeker_confirmation(call)
    liquid_mail(:call_final_confirmation_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call)
  end

  def expert_confirmation(call)
    liquid_mail(:call_final_confirmation_to_expert, { to: call.expert.notification_email }, user: call.expert, call: call)
  end

  def call_declined_by_expert_to_seeker(call)
    liquid_mail(:call_declined_by_expert_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call)
  end

  def call_declined_by_expert_manually(call)
    liquid_mail(:call_declined_by_expert_manually, { to: call.expert.notification_email }, user: call.expert, call: call)
  end

  def call_declined_by_expert_auto(call)
    liquid_mail(:call_declined_by_expert_auto, { to: call.expert.notification_email }, user: call.expert, call: call)
  end

  def call_reminder_to_seeker(call)
    liquid_mail(:call_reminder_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call)
  end

  def call_reminder_to_expert(call)
    liquid_mail(:call_reminder_to_expert, { to: call.expert.notification_email }, user: call.expert, call: call)
  end

  def call_followup_to_seeker(call)
    liquid_mail(:call_followup_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call)
  end

  def call_cancelled_by_seeker_to_seeker(call)
    liquid_mail(:call_cancelled_by_seeker_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call)
  end

  def call_cancelled_by_seeker_to_expert(call)
    liquid_mail(:call_cancelled_by_seeker_to_expert, { to: call.expert.notification_email }, user: call.expert, call: call)
  end

  def call_cancelled_by_expert_to_seeker(call)
    liquid_mail(:call_cancelled_by_expert_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call)
  end

  def call_cancelled_by_expert_to_expert(call)
    liquid_mail(:call_cancelled_by_expert_to_expert, { to: call.expert.notification_email }, user: call.expert, call: call)
  end

end
