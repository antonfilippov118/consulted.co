
class Review

  include Mongoid::Document
  include Mongoid::Timestamps
  include Validatable::Review
  include Scopable::Review

  has_one :call
  belongs_to :offer

  field :awesome, type: Boolean, default: false

  field :understood_problem, type: Integer
  field :helped_solve_problem, type: Integer
  field :knowledgeable, type: Integer
  field :value_for_money, type: Integer
  field :would_recommend, type: Integer

  field :feedback, type: String

  field :would_recommend_consulted, type: Integer
end
