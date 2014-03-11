class Favorite
  include Mongoid::Document
  field :user_id, type: Integer # this is the favarite_user_id
  embedded_in :user
end
