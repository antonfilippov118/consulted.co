class Contact
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :email, :message, :subject

  validates_presence_of :name, :email, :subject, :message

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def send!
    return false unless valid?
    begin
      ContactMailer.send_contact_request(self).deliver!
    rescue
      return false
    end
    true
  end
end
