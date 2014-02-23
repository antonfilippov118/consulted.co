class User::LinkedinCompany
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user

  field :linkedin_id
  field :industry
  field :name
end
