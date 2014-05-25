class User::LinkedinCompany::Address
  include Mongoid::Document

  embedded_in :company, class_name: 'User::LinkedinCompany'
  field :city, default: ''
  field :postal_code, default: ''
  field :street1, default: ''
  field :street2, default: ''
  field :street3, default: ''
  field :fax, default: ''
  field :phone, default: ''

  def street
    %Q{#{street1}
      #{street2}
      #{street3}}
  end
end
