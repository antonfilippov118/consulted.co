class User::LinkedinConnection
  include Mongoid::Document

  embedded_in :user

  field :token
  field :secret
  field :public_profile_url
  field :last_synchronization, type: DateTime
end
