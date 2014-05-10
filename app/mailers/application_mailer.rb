class ApplicationMailer < ActionMailer::Base
  protected

  def liquid_mail(action, opts, variables = nil)
    liquid_variables = collect_liquid_variables

    if variables.nil?
      mail_opts = opts
    else
      [:expert, :user, :seeker].each do |sym|
        initialize_from_record(variables[sym]) unless variables[sym].nil?
      end
      liquid_variables.merge!(variables)
      mail_opts = headers_for(action, opts)
    end

    template = EmailTemplate.find_by(name: action)
    send_liquid_mail(mail_opts, liquid_variables, template)
  rescue Mongoid::Errors::DocumentNotFound
    send_non_liquid_mail(mail_opts, action)
  end

  def send_liquid_mail(mail_opts, liquid_variables, template)
    mail_opts[:subject] ||= template.subject
    mail_opts[:from] ||= determine_email_from(template)

    variables = liquid_variables.stringify_keys

    binding.pry

    mail(mail_opts) do |format|
      format.text { render text: template.render(variables, 'text') }
      format.html { render text: template.render(variables, 'html') }
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
