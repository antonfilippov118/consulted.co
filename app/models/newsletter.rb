class Newsletter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  validates_presence_of :email
  validates_format_of :email, with: /.*\@.*/
  attr_accessor :email

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def send!
    return false unless valid?
    begin
      gibbon.lists.subscribe list.symbolize_keys.merge email: { 'email' => email }, double_optin: 'false', update_existing: 'true'
    rescue
      return false
    end
    true
  end

  private

  def list
    data = Gibbon::API.lists.list(filters: { list_name: 'Consulted Beta information' }).fetch('data').first
    data.slice 'id', 'web_id'
  end

  def gibbon
    Gibbon::API.new
  end
end
