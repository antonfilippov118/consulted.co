class User::Favorite
  include Mongoid::Document
  field :favorite_id, type: String # this is the favarite_user_id / deprecated
  # has_one :user
  embedded_in :user
end
