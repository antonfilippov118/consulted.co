class ContactMailer < ActionMailer::Base
  default from: 'Consulted Website <no-reply@consulted.co>'
  def send_contact_request(contact)
    @contact = contact
    mail(to: 'support@consulted.co', reply_to: "#{contact.name} <#{@contact.notification_email}>", subject: @contact.subject)
  end

  def find_expert_request(group, user)
    @user, @group = user, group
    mail(to: 'support@consulted.co', reply_to: "#{user.name} <#{@user.notification_email}>", subject: "Find an expert in #{group.name}")
  end
end
