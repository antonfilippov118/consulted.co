class Category
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :qualification, type: String
  field :looking_for, type: String
  field :experience, type: String

  embedded_in :group
end
