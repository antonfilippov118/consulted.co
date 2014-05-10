namespace :emails do
  desc 'Creates the email templates for the platform'
  task create: :environment do
    EmailTemplate.delete_all
    templates.each do |template|
      EmailTemplate.create template
    end
  end

  def templates
    [
      {
        name: 'signup_confirmation',
        subject: 'Please verify your email address',
        html_version: %Q(<h6>Hello {{user.name}}!</h6>
<p>Thanks for creating an account with CONSULTED. Click below to confirm your email address:</p>
<p><a href="{{confirmation_url}}">{{user.email}}</a></p>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hello {{user.name}}!
Thanks for creating an account with CONSULTED.

Plese use this URL to confirm you email address: {{confirmation_url}}

Thanks,
CONSULTED
)
      }
    ]
  end
end