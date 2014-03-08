class User
  include Mongoid::Document

  field :user_id, type: Int
  field :summary, type: String
  field :newsletter, type: Boolean
  field :languages, type: Array, default: ['english']
  field :slug, type: String
  field :timezone, type: String, default: 'Europe/Berlin'

  field :providers, type: Array


end
