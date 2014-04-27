FactoryGirl.define do
  factory :email_template do
    trait :confirmation_instructions do
      name 'confirmation_instructions'
      subject 'Confirmation instructions'
      from 'registration@consulted.co'

      html_version %Q(
        <p>Welcome {{ email }}!</p>
        <p>You can confirm your account email through the link below:</p>
        <p>{{ 'Confirm my account' | link_to_confirmation: id, token }}</p>
      )

      text_version %Q(
        Welcome {{ email }}!

        You can confirm your account email through the link below:

        {{ '' | confirmation_url: id, token }}
      )
    end

    trait :reset_password_instructions do
      name 'reset_password_instructions'
      subject 'Reset password instructions'
      from 'system@consulted.co'

      html_version %Q(
        <p>Hello {{ email }}!</p>
        <p>Someone has requested a link to change your password. You can do this through the link below.</p>
        <p>{{ 'Change my password' |  link_to_edit_password: id, token }}</p>
        <p>If you didn't request this, please ignore this email.</p>
        <p>Your password won't change until you access the link above and create a new one.</p>
      )

      text_version %Q(
        Hello {{ email }}!

        Someone has requested a link to change your password. You can do this through the link below.

        {{ '' | edit_password_url: id, token }}

        If you didn't request this, please ignore this email.

        Your password won't change until you access the link above and create a new one.
      )
    end

    trait :admin_welcome do
      name 'admin_welcome'
      subject 'Your are the new admin at consulted.co'
      from 'registration@consulted.co'

      html_version %Q(
        <p>Welcome admin!</p>
        <p>You can use your email/password to login to admin area through the link below:</p>
        <p>{{ 'Admin area' | link_to_admin }}</p>
      )

      text_version %Q(
        Welcome admin!

        You can use your email/password to login to admin area through the link below:

        {{ '' | admin_url }}
      )
    end

    trait :request_notification do
      name 'request_notification'
      subject 'You have a new request for a call!'
      from 'new-request@consulted.co'

      html_version %Q(
        <h3>New request for a call!</h3>
        <p class="lead">Hello {{ expert.name }}!</p>
        <p>You have a new call request!</p>
      )

      text_version %Q(
        New request for a call!

        Hello {{ expert.name }}
        You have a new call request!
      )
    end

    trait :request_cancellation do
      name 'request_cancellation'
      subject 'A request has been cancelled!'
      from 'new-request@consulted.co'

      html_version %Q(
        <h3>A call request has been cancelled!</h3>
        <p>Hi {{ expert.name }}</p>
        <p>A request for a call in {{ request.name }} has just been cancelled by a user!</p>
      )

      text_version %Q(
        A call request has been cancelled!

        Hi {{ expert.name }}
        A request for a call in {{ request.name }} has just been cancelled by a user!
      )
    end
  end
end
