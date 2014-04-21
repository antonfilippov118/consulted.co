class User::LinkedinEducation
  include Mongoid::Document

  embedded_in :user

  field :name
  field :degree
  field :from, type: Integer, default: 0
  field :to, type: Integer, default: 0
  field :notes
  field :field

end
