class User
  include Mongoid::Document

  field :user_id, type: Integer
  field :fav_user_id, type: Integer

end
