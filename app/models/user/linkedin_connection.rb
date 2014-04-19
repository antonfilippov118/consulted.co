class User::LinkedinConnection
  include Mongoid::Document

  embedded_in :user

  field :token
  field :secret
  field :last_synchronization, type: DateTime
end
