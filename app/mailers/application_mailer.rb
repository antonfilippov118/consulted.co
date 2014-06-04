class ApplicationMailer < ActionMailer::Base
  include Devise::Mailers::Helpers

  protected

  def liquid_mail(action, opts, variables = {})
    init variables
    variables = liquid_variables.merge(settings).merge(variables)
    mail_opts = headers_for(action, opts)
    template = EmailTemplate.find_by(name: action)
    send_liquid_mail(mail_opts, variables, template)
  rescue Mongoid::Errors::DocumentNotFound
    send_non_liquid_mail(mail_opts, action)
  end

  def send_liquid_mail(mail_opts, liquid_variables, template)
    variables = liquid_variables.stringify_keys.merge(urls).merge created_attachments
    mail_opts[:subject] = Liquid::Template.parse(template.subject).render variables
    mail_opts[:from] = determine_email_from(template)

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

  def liquid_variables
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

  def init(variables)
    [:expert, :user, :seeker].each do |sym|
      initialize_from_record(variables[sym]) unless variables[sym].nil?
    end
  end

  def settings
    keys = Settings.fields.keys
    keys.delete '_id'
    keys.map { |key| { key => Settings.send(key) } }.reduce(:merge)
  end

  def created_attachments
    logos.each do |logo|
      attachments.inline["#{logo}.png"] = File.read Rails.root.join('app', 'assets', 'templates', "#{logo}.png")
    end
    logos.map { |logo| { "#{logo}_png" => attachments.inline["#{logo}.png"].url } }.reduce :merge
  end

  def logos
    %w(consulted twitter linkedin facebook google)
  end

  def format
    '%A, %B %-d %Y, %I:%M%P'
  end

  def urls
    {
      'root_url' => root_url,
      'settings_url' => settings_url,
      'terms_url' => terms_url,
      'privacy_url' => privacy_url,
      'login_url' => new_user_session_url
    }.merge static_urls
  end

  def static_urls
    {
      'dialin_numbers_url' => 'https://consultedco.zendesk.com/hc/en-us/articles/201304524',
      'call_declining_url' => 'https://consultedco.zendesk.com/hc/en-us/articles/201304974',
      'compensation_for_seeker_url' => 'https://consultedco.zendesk.com/hc/en-us/articles/201304794',
      'compensation_for_expert_url' => 'https://consultedco.zendesk.com/hc/en-us/articles/201304994',
      'cancellation_by_seeker_url' => 'https://consultedco.zendesk.com/hc/en-us/articles/201304784',
      'cancellation_by_expert_url' => 'https://consultedco.zendesk.com/hc/en-us/articles/201322580'
    }
  end
end
