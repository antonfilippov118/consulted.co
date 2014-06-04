class CallMailer < ApplicationMailer

  def seeker_confirmation(call)
    liquid_mail(:call_final_confirmation_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call, date: date(call, :seeker), timezone: timezone(call, :seeker))
  end

  def expert_confirmation(call)
    liquid_mail(:call_final_confirmation_to_expert, { to: call.expert.notification_email }, user: call.expert, call: call, date: date(call, :expert), timezone: timezone(call, :expert))
  end

  def call_declined_by_expert_to_seeker(call)
    liquid_mail(:call_declined_by_expert_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call, date: date(call, :seeker), timezone: timezone(call, :seeker))
  end

  def call_declined_by_expert_manually(call)
    liquid_mail(:call_declined_by_expert_manually, { to: call.expert.notification_email }, user: call.expert, call: call, date: date(call, :expert), timezone: timezone(call, :seeker))
  end

  def call_declined_by_expert_auto(call)
    liquid_mail(:call_declined_by_expert_auto, { to: call.expert.notification_email }, user: call.expert, call: call, date: date(call, :expert), timezone: timezone(call, :seeker))
  end

  def call_reminder_to_seeker(call)
    liquid_mail(:call_reminder_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call, date: date(call, :seeker), timezone: timezone(call, :seeker))
  end

  def call_reminder_to_expert(call)
    liquid_mail(:call_reminder_to_expert, { to: call.expert.notification_email }, user: call.expert, call: call, date: date(call, :expert), timezone: timezone(call, :expert))
  end

  def call_followup_to_seeker(call)
    liquid_mail(:call_followup_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call, date: date(call, :seeker), timezone: timezone(call, :seeker))
  end

  def call_cancelled_by_seeker_to_seeker(call)
    liquid_mail(:call_cancelled_by_seeker_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call, date: date(call, :seeker), timezone: timezone(call, :seeker))
  end

  def call_cancelled_by_seeker_to_expert(call)
    liquid_mail(:call_cancelled_by_seeker_to_expert, { to: call.expert.notification_email }, user: call.expert, call: call, date: date(call, :expert), timezone: timezone(call, :expert))
  end

  def call_cancelled_by_expert_to_seeker(call)
    liquid_mail(:call_cancelled_by_expert_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call, date: date(call, :seeker), timezone: timezone(call, :seeker))
  end

  def call_cancelled_by_expert_to_expert(call)
    liquid_mail(:call_cancelled_by_expert_to_expert, { to: call.expert.notification_email }, user: call.expert, call: call, date: date(call, :expert), timezone: timezone(call, :expert))
  end

  def call_abandoned_by_seeker_to_expert(call)
    liquid_mail(:call_abandoned_by_seeker_to_expert, { to: call.expert.notification_email }, user: call.expert, call: call, date: date(call, :expert), timezone: timezone(call, :expert))
  end

  def call_abandoned_by_seeker_to_seeker(call)
    liquid_mail(:call_abandoned_by_seeker_to_seeker, { to: call.seeker.notification_email }, user: call.seeker, call: call, date: date(call, :seeker), timezone: timezone(call, :seeker))
  end

  def expert_notification(call)
    liquid_mail(:call_requested_to_expert, { to: call.expert.notification_email }, call: call, user: call.expert, date: date(call, :expert), timezone: timezone(call, :expert))
  end

  def seeker_notification(call)
    liquid_mail(:call_requested_by_seeker, { to: call.seeker.notification_email }, call: call, user: call.seeker, date: date(call, :expert), timezone: timezone(call, :expert))
  end

  private

  def date(call, partner)
    partner = call.send partner
    tz = partner.timezone
    if tz.present?
      date = Time.at(call.active_from).in_time_zone(tz)
    else
      date = call.active_from.utc
    end
    date.strftime '%A, %B %-d %Y, %H:%M'
  end

  def timezone(call, partner)
    partner = call.send partner
    ActiveSupport::TimeZone.new(partner.timezone).to_s
  end
end
