class ApplicationMailer < ActionMailer::Base
  protected

  def liquid_mail(action, opts, record = nil)
    liquid_variables = collect_liquid_variables

    if record
      initialize_from_record(record)
      liquid_variables.merge!(record.to_liquid.stringify_keys)
      mail_opts = headers_for(action, opts)
    else
      mail_opts = opts
    end

    template = EmailTemplate.find_by(name: action)
    send_liquid_mail(mail_opts, liquid_variables, template)
  rescue Mongoid::Errors::DocumentNotFound
    send_non_liquid_mail(mail_opts, action)
  end

  def send_liquid_mail(mail_opts, liquid_variables, template)
    mail_opts[:subject] ||= template.subject
    mail_opts[:from] ||= determine_email_from(template)

    mail(mail_opts) do |format|
      format.text { render text: template.render(liquid_variables, 'text') }
      format.html { render text: template.render(liquid_variables, 'html') }
    end
  end

  def send_non_liquid_mail(mail_opts, action)
    mail_opts[:template_name] ||= action
    mail_opts[:from] ||= Settings.email_default_from

    mail(mail_opts)
  end

  def collect_liquid_variables
    {}.tap do |result|
      instance_variables.each do |variable|
        next if variable.to_s =~ /@_/
        key = variable.to_s.sub('@', '')
        liquid_variable = instance_variable_get(variable)
        liquid_variable = liquid_variable.to_liquid.try(:stringify_keys) if liquid_variable.respond_to?(:to_liquid)

        result[key] = liquid_variable
      end
    end
  end

  def determine_email_from(template)
    template.from.presence || Settings.email_default_from
  end
end
