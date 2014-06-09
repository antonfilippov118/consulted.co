module Reviewable

  module Offer
    extend ActiveSupport::Concern

    def recent_awesome_calls_cost(calls_count = 5)
      # ???
      # since mongodb has no joins, getting 5 *latest calls* with awesome
      # rating has no fast solutions
      # getting calls for 5 *last reviews* is much faster
      recent_calls = reviews.awesomes.desc(:created_at).limit(calls_count).map(&:call).compact
      return nil if recent_calls.empty?
      recent_rates = recent_calls.map(&:initial_rate)
      (recent_rates.reduce(:+).to_f / recent_rates.count.to_f) / 100.0
    end

    def likes
      reviews.awesomes.count
    end

    included do
      has_many :reviews
    end
  end

end
