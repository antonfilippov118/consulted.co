require 'spec_helper'

describe Contact do

  let(:contact) { Contact.new }

  [:message, :subject, :name, :email].each do |sym|
    it "should have a #{sym} field" do
      expect(-> { contact.send(sym) }).not_to raise_error
    end
  end

  it 'should not do anything, if not valid' do
    contact.message = 'fooo'
    expect(contact.send!).to be_false
  end

  it 'should send an email to support if valid' do
    contact.message = 'Foo'
    contact.name = 'Florian'
    contact.email = 'FlorianKraft@consulted.co'
    contact.subject = 'Testsubject'
    contact.send!

    expect(mail).not_to be_nil
  end

  it 'should have the subject given by the user' do
    contact.message = 'Foo'
    contact.name = 'Florian'
    contact.email = 'FlorianKraft@consulted.co'
    contact.subject = 'Testsubject'

    contact.send!
    expect(mail.subject).to eql contact.subject
  end

  def mail
    ActionMailer::Base.deliveries.last
  end
end
