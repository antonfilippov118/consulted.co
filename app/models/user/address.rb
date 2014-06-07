class User::Address
  include Mongoid::Document
  embedded_in :user

  [:street, :postal_code, :city, :state].each do |_field|
    field _field, type: String, default: ''
  end

  field :country, type: Country
end
