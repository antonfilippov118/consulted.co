class CallMailer < ApplicationMailer
  def seeker_confirmation(call)
    liquid_mail(:call_final_confirmation_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call)
  end

  def expert_confirmation(call)
    liquid_mail(:call_final_confirmation_to_expert, { to: call.expert.notification_email }, user: call.expert, call: call)
  end

  def expert_declined_to_seeker

  end

  def expert_declined_to_expert

  end

  def seeker_cancelled_to_seeker

  end

  def seeker_cancelled_to_expert

  end

  def expert_cancelled_to_seeker

  end

  def expert_cancelled_to_expert

  end
end
