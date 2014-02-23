class User::LinkedinEducation
  include Mongoid::Document

  embedded_in :user

  field :name
  field :from, type: Integer
  field :to, type: Integer
  field :degree

end
