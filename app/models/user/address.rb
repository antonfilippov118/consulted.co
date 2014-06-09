class User::Address
  include Mongoid::Document
  embedded_in :user

  [:street, :postal_code, :city, :state, :company].each do |_field|
    field _field, type: String, default: ''
  end

  field :country, type: Country
end
