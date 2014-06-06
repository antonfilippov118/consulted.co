module Validatable
  module Review
    extend ActiveSupport::Concern

    included do
      star_fields = [:understood_problem, :helped_solve_problem, :knowledgeable, :value_for_money, :would_recommend]
      validates_numericality_of star_fields, only_integer: true, greater_than_or_equal_to: 1, message: 'must be between 1 and 5!'
      validates_numericality_of star_fields, only_integer: true, less_than_or_equal_to: 5, message: 'must be between 1 and 5!'

      validates_numericality_of :would_recommend_consulted, only_integer: true, greater_than_or_equal_to: 0, message: 'must be between 0 and 10!'
      validates_numericality_of :would_recommend_consulted, only_integer: true, less_than_or_equal_to: 10, message: 'must be between 0 and 10!'
    end
  end
end
