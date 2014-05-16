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
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>Thanks for creating an account with CONSULTED. Click below to confirm your email address:</p>
<p><a href="{{confirmation_url}}">{{user.email}}</a></p>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
Thanks for creating an account with CONSULTED.

Plese use this URL to confirm you email address: {{confirmation_url}}

Thanks,
CONSULTED
)
      },
      {
        name: 'signup_confirmation_reminder',
        subject: 'Reminder to verify your email address',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>About a day ago you created an account with CONSULTED. This is a quick reminder to confirm your
email address. Simply click the link below to confirm:</p>
<p><a href="{{confirmation_url}}">{{user.email}}</a></p>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
About a day ago you created an account with CONSULTED. This is a quick reminder to confirm your
email address.

Plese use this URL to confirm you email address: {{confirmation_url}}

Thanks,
CONSULTED
)
      },
      {
        name: 'account_deletion',
        subject: 'Your account was closed',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>This is to confirm that your account was closed. </p>
<p>Please contact <a href="mailto:support@consulted.co">Support</a> if you feel this has been done in error.</p>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
This is to confirm that your account was closed.

Please contact Support (support@consulted.co) if you feel this has been done in error.

Thanks,
CONSULTED
)
      },
      {
        name: 'forgotten_password',
        subject: 'Forgotten password request',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>We received a request for a forgotten password.</p>
<p>To change your CONSULTED password, please click the link below:</p>
<p><a href="{{reset_url}}">LINK</a></p>
<p>If you did not request this change, you do not need to do anything.</p>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
We received a request for a forgotten password.

To change your CONSULTED password, please use the URL below:

{{reset_url}}

If you did not request this change, you do not need to do anything.

Thanks,
CONSULTED
)
      },
      {
        name: 'funds_paid_out',
        subject: 'Funds paid out to you – thanks for being an expert!',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>A payment of <strong>{{ amount | currency }}<strong> was paid out.</p>
<h4>Payment information</h4>
<ul>
<li>Date: {{ date }}</li>
<li>Amount: {{ amount | currency}} </li>
<li>Payment Method: PayPal</li>
</ul>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
A payment of <strong>{{ amount | currency }}<strong> was paid out.

Payment information:

- Date: {{ date}}
- Amount: {{ amount | currency }}
- Payment Method: PayPal

Thanks,
CONSULTED
)
      },
      {
        name: 'payment_received',
        subject: 'Payment received – thanks!',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>A payment of <strong>{{ amount | currency }}<strong> was received.</p>
<h4>Payment information</h4>
<ul>
<li>Date: {{ date }}</li>
<li>Amount: {{ amount | currency}} </li>
<li>Payment Method: PayPal</li>
</ul>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
A payment of <strong>{{ amount | currency }}<strong> was received.

Payment information:

- Date: {{ date}}
- Amount: {{ amount | currency }}
- Payment Method: PayPal

Thanks,
CONSULTED
)
      },
      {
        name: 'call_requested_by_seeker',
        subject: 'Call request sent',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>You successfully requested a call with {{call.expert.name}}.</p>
<p>This is <strong>not a final confirmation</strong>. The expert has {{ meeting_timeout }} hours to accept the meeting request. We will let you know, once this happens.</p>
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.expert.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Pending confirmation</li>
<li>Meeting via: Call bridge (you will receive the dial-in number and access code in the final confirmation)</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Your message to the expert: {{call.message}}</li>
</ul>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
You successfully requested a call with {{call.expert.name}}.

This is not a final confirmation. The expert has {{ meeting_timeout }} hours to accept the meeting request. We will let you know, once this happens.

Meeting request details

- Meeting partner: {{call.expert.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Pending confirmation
- Meeting via: Call bridge (you will receive the dial-in number and access code in the final confirmation)
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Your message to the expert: {{call.message}}

Thanks,
CONSULTED
)
      },
      {
        name: 'call_requested_to_expert',
        subject: 'You have a new call request – please respond',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>You received a request for a call with {{call.seeker.name}}. The call is <strong>not confirmed yet</strong>.</p>
<p>Please <a href="{{login_url}}">login into CONSULTED to accept the request</a>. You have {{meeting_timeout}} hours to accept or decline the meeting request.</p>
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.seeker.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Pending confirmation</li>
<li>Meeting via: Call bridge (you will receive the dial-in number and access code in the final confirmation)</li>
<li>Language: {{call.expseekerert.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Meeting partner message {{call.message}}</li>
</ul>
<p>Note: There may be a fee if you cancel this meeting after you accepted it. See our <a href="{{cancellation_url}}">cancellation policy</a></p>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
You received a request for a call with {{call.seeker.name}}. The call is not confirmed yet.

Please login into CONSULTED to accept the request ({{login_url}}). You have {{meeting_timeout}} hours to accept or decline the meeting request.

This is not a final confirmation. The expert has {{ meeting_timeout }} hours to accept the meeting request. We will let you know, once this happens.

Meeting request details

- Meeting partner: {{call.seeker.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Pending confirmation
- Meeting via: Call bridge (you will receive the dial-in number and access code in the final confirmation)
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Your message to the expert: {{call.message}}

Note: There may be a fee if you cancel this meeting after you accepted it. See our cancellation policy ({{cancellation_url}}).

Thanks,
CONSULTED
)
      },
      {
        name: 'call_final_confirmation_to_seeker',
        subject: 'Call confirmed!',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>{{call.expert.name}} accepted your call request - your <strong>call is now confirmed</strong>.</p>
<p>As per <a href="{{settings_url}}">your settings</a> you will receive a call reminder {{user.notification_time}} minutes before the call.
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.expert.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Confirmed</li>
<li>Meeting via: Call bridge</li>
<li>US toll-free number: +##########</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Your message to the expert: {{call.message}}</li>
</ul>
<p>Note: There may be a fee if you cancel this meeting. See our <a href="{{cancellation_url}}">cancellation policy</a></p>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
{{call.expert.name}} accepted your call request - your call is now confirmed.

As per your settings ({{settings_url}}) you will receive a call reminder {{user.notification_time}} minutes before the call.

Meeting request details

- Meeting partner: {{call.expert.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Confirmed
- US toll-free number: +##########
- Meeting via: Call bridge (you will receive the dial-in number and access code in the final confirmation)
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Your message to the expert: {{call.message}}

Note: There may be a fee if you cancel this meeting after you accepted it. See our cancellation policy ({{cancellation_url}}).

Thanks,
CONSULTED
)
      },
      {
        name: 'call_final_confirmation_to_expert',
        subject: 'Call confirmed!',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>The call with {{call.seeker.name}} <strong>is confirmed</strong>.</p>
<p>As per <a href="{{settings_url}}">your settings</a> you will receive a call reminder {{user.notification_time}} minutes before the call.
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.seeker.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Confirmed</li>
<li>Meeting via: Call bridge</li>
<li>US toll-free number: +##########</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Meeting partner message: {{call.message}}</li>
</ul>
<p>Note: There may be a fee if you cancel this meeting. See our <a href="{{cancellation_url}}">cancellation policy</a></p>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
The call with {{call.seeker.name}} is now confirmed.

As per your settings ({{settings_url}}) you will receive a call reminder {{user.notification_time}} minutes before the call.

Meeting request details

- Meeting partner: {{call.seeker.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Confirmed
- Meeting via: Call bridge
- US toll-free number: +##########
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Your message to the expert: {{call.message}}

Note: There may be a fee if you cancel this meeting after you accepted it. See our cancellation policy ({{cancellation_url}}).

Thanks,
CONSULTED
          )
      },
      {
        name: 'call_declined_by_expert_to_seeker',
        subject: ' Call declined',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>The call with {{call.expert.name}} <strong>was declined</strong>, either by the expert or automatically if
the expert did not respond.</p>
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.expert.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Declined</li>
<li>Meeting via: Call bridge</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Your message to the expert: {{call.message}}</li>
</ul>
<p>While this can happen from time to time, this is certainly not the norm. We constantly follow up with experts to ensure fast responses and updated availability. Please browse other experts on <a href="{{root_url}}">consulted.co</a>
who may be able to answer your questions.
</p>
<p>Thanks,<br>CONSULTED</p>
),
        text_version: %Q(Hi {{user.name}}!
The call with {{call.expert.name}} was declined, either by the expert or automatically if
the expert did not respond.

As per your settings ({{settings_url}}) you will receive a call reminder {{user.notification_time}} minutes before the call.

Meeting request details

- Meeting partner: {{call.expert.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Declined
- Meeting via: Call bridge
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Your message to the expert: {{call.message}}

Note: There may be a fee if you cancel this meeting after you accepted it. See our cancellation policy ({{cancellation_url}}).

Thanks,
CONSULTED)
      },
      {
        name: 'call_declined_by_expert_manually',
        subject: 'Call declined (by you)',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>You <strong>declined the call</strong> with {{call.seeker.name}}</p>
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.seeker.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Declined</li>
<li>Meeting via: Call bridge</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Meeting partner message: {{call.message}}</li>
</ul>
<p>Note: Declining frequently may have a negative impact on your rankings on CONSULTED or your ability
to offer your time. You can learn more <a href="#">here</p>
<p>Thanks,<br>CONSULTED</p>
),
        text_version: %Q(Hi {{user.name}}!
You declined the call with {{call.seeker.name}}.

Meeting request details

- Meeting partner: {{call.seeker.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Declined
- Meeting via: Call bridge
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Meeting partner message: {{call.message}}

Note: Declining frequently may have a negative impact on your rankings on CONSULTED or your ability
to offer your time.

Thanks,
CONSULTED)
      },
      {
        name: 'call_declined_by_expert_auto',
        subject: 'Call declined (by system)',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>The call request from {{call.seeker.name}} you received <strong>was automatically declined</strong> because you did not respond within the confirmation period of {{meeting_timeout}} hours.</p>
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.seeker.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Declined</li>
<li>Meeting via: Call bridge</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Meeting partner message: {{call.message}}</li>
</ul>
<p>Note: Declining frequently may have a negative impact on your rankings on CONSULTED or your ability
to offer your time. You can learn more <a href="#">here</p>
<p>Thanks,<br>CONSULTED</p>
),
        text_version: %Q(Hi {{user.name}}!
The call request from {{call.seeker.name}} you received was automatically declined because you did not respond within the confirmation period of {{meeting_timeout}} hours.

Meeting request details

- Meeting partner: {{call.seeker.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Declined
- Meeting via: Call bridge
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Meeting partner message: {{call.message}}

Note: Declining frequently may have a negative impact on your rankings on CONSULTED or your ability
to offer your time.

Thanks,
CONSULTED)
      },
      {
        name: 'call_reminder_to_seeker',
        subject: 'Call reminder',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>As per <a href="{{settings_url}}">your settings</a> this is the call reminder for your call on {{date}}.</p>
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.expert.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Confirmed</li>
<li>Meeting via: Call bridge</li>
<li>US toll-free number: +##########</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Your message to the expert: {{call.message}}</li>
</ul>
<p>Note: There may be a fee if you cancel this meeting. See our <a href="{{cancellation_url}}">cancellation policy</a></p>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
The call with {{call.expert.name}} is now confirmed.

As per your settings ({{settings_url}}) this is the call reminder for your call on {{date}}.

Meeting request details

- Meeting partner: {{call.expert.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Confirmed
- Meeting via: Call bridge
- US toll-free number: +##########
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Your message to the expert: {{call.message}}

Note: There may be a fee if you cancel this meeting after you accepted it. See our cancellation policy ({{cancellation_url}}).

Thanks,
CONSULTED)
      },
      {
        name: 'call_reminder_to_expert',
        subject: 'Call reminder',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>As per <a href="{{settings_url}}">your settings</a> this is the call reminder for your call on {{date}}.</p>
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.seeker.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Confirmed</li>
<li>Meeting via: Call bridge</li>
<li>US toll-free number: +##########</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Meeting partner message: {{call.message}}</li>
</ul>
<p>Note: There may be a fee if you cancel this meeting. See our <a href="{{cancellation_url}}">cancellation policy</a></p>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
As per your settings ({{settings_url}}) this is the call reminder for your call on {{date}}.

Meeting request details

- Meeting partner: {{call.expert.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Confirmed
- Meeting via: Call bridge
- US toll-free number: +##########
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Your message to the expert: {{call.message}}

Note: There may be a fee if you cancel this meeting after you accepted it. See our cancellation policy ({{cancellation_url}}).

Thanks,
CONSULTED)
      },
      {
        name: 'call_followup_to_seeker',
        subject: 'Your past call',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>You recently completed the call with {{call.expert.name}} on {{date}}.</p>
<p>Please rate the call (takes less than 1 minute) <a href="{{rating_url}}">here</a>. Thanks for making CONSULTED better!</p>
<p>If you have any questions, you can reach out to our <a href="mailto:support@consulted.co">support team</a> at any time.</p>
<p>Thanks,<br>CONSULTED</p>
),
        text_version: %Q(Hi {{user.name}}!
You recently completed the call with {{call.expert.name}} on {{date}}.

Please rate the call (takes less than 1 minute) under the following url:

{{rating_url}}

If you have any questions, you can reach out to our support team (support@consulted.co) at any time. Thanks for making CONSULTED better!

Thanks,
CONSULTED
)
      },
      {
        name: 'call_cancelled_by_seeker_to_seeker',
        subject: 'Call cancelled',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p><strong>You cancelled the call</strong> with {{call.expert.name}}. As per our <a href="{{cancellation_url}}">cancellation policy</a> we may charge a cancellation fee if the call was previously confirmed.</p>
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.expert.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Cancelled</li>
<li>Meeting via: Call bridge</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Your message to the expert: {{call.message}}</li>
</ul>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
You cancelled the call with {{call.expert.name}}. As per our cancellation policy ({{cancellation_url}}) we may charge a cancellation fee if the call was previously confirmed.

Meeting request details

- Meeting partner: {{call.expert.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Cancelled
- Meeting via: Call bridge
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Your message to the expert: {{call.message}}

Thanks,
CONSULTED)
      },
      {
        name: 'call_cancelled_by_seeker_to_expert',
        subject: 'Call cancelled',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>Your call with {{call.seeker.name}} <strong>was cancelled by the meeting partner</strong>. As per our <a href="{{cancellation_url}}">cancellation policy</a> you may receive a compensation if the call was previously confirmed.</p>
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.seeker.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Cancelled</li>
<li>Meeting via: Call bridge</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Meeting partner message: {{call.message}}</li>
</ul>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
Your call with {{call.seeker.name}} was cancelled by the meeting partner. As per our cancellation policy ({{cancellation_url}}) you may receive a compensation if the call was previously confirmed.

Meeting request details

- Meeting partner: {{call.expert.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Cancelled
- Meeting via: Call bridge
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Meeting partner message: {{call.message}}

Thanks,
CONSULTED
)
      },
      {
        name: 'call_cancelled_by_expert_to_seeker',
        subject: 'Call cancelled',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p>Your call with {{call.expert.name}} <strong>was cancelled by the expert</strong>. As per our <a href="{{cancellation_url}}">cancellation policy</a> you may receive a compensation if the call was previously confirmed.</p>
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.expert.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Cancelled</li>
<li>Meeting via: Call bridge</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Your message to the expert: {{call.message}}</li>
</ul>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
Your call with {{call.expert.name}} was cancelled by the expert. As per our cancellation policy ({{cancellation_url}}) you may receive a compensation if the call was previously confirmed.

Meeting request details

- Meeting partner: {{call.expert.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Cancelled
- Meeting via: Call bridge
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Meeting partner message: {{call.message}}

Thanks,
CONSULTED
)
      },
      {
        name: 'call_cancelled_by_expert_to_expert',
        subject: 'Call cancelled',
        html_version: %Q(<h3>Hi {{user.name}}!</h3>
<p><strong>You cancelled the call</strong> with {{call.seeker.name}}. As per our <a href="{{cancellation_url}}">cancellation policy</a> we may charge a cancellation fee if the call was previously confirmed.</p>
<h4>Meeting request details</h4>
<ul>
<li>Meeting partner: {{call.seeker.name}}</li>
<li>Service offering: {{call.name}}</li>
<li>Date &amp; Time: {{ date }}</li>
<li>Duration: {{ call.duration }} minutes</li>
<li>Status: Cancelled</li>
<li>Meeting via: Call bridge</li>
<li>Language: {{call.languages}}</li>
<li>Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)</li>
<li>Payment: PayPal</li>
<li>Meeting partner message: {{call.message}}</li>
</ul>
<p>Thanks,<br>CONSULTED</p>),
        text_version: %Q(Hi {{user.name}}!
You cancelled the call with {{call.seeker.name}}. As per our cancellation policy ({{cancellation_url}}) we may charge a cancellation fee if the call was previously confirmed.

Meeting request details

- Meeting partner: {{call.seeker.name}}
- Service offering: {{call.name}}
- Date &amp; Time: {{ date }}
- Duration: {{ call.duration }} minutes
- Status: Cancelled
- Meeting via: Call bridge
- Language: {{call.languages}}
- Rate: {{rate}} USD (based on {{rate}} USD/hour; includes our fee)
- Payment: PayPal
- Meeting partner message: {{call.message}}

Thanks,
CONSULTED)
      }
    ]
  end
end
