class ContactMailer < ActionMailer::Base
  default from: 'Consulted Website <no-reply@consulted.co>'
  def send_contact_request(contact)
    @contact = contact
    mail(to: 'support@consulted.co', reply_to: "#{contact.name} <#{@contact.email}>", cc: @contact.email, subject: @contact.subject)
  end
end
