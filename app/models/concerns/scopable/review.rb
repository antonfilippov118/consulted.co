module Scopable

  module Review
    extend ActiveSupport::Concern

    included do
      scope :awesomes, -> { where awesome: true }
    end
  end

end
