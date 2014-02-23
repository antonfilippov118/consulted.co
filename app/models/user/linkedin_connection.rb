class User::LinkedinConnection
  include Mongoid::Document

  embedded_in :user

  field :token
  field :secret
end
