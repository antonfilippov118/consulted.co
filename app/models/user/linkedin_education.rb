class User::LinkedinEducation
  include Mongoid::Document

  embedded_in :user

  field :name
  field :degree

end
