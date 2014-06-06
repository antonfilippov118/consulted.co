module Reviewable

  module Call
    extend ActiveSupport::Concern

    def can_be_reviewed?
      complete? && !has_review?
    end

    included do
      belongs_to :review, dependent: :destroy

      def create_review(attributes = nil)
        attributes = (attributes || {}).merge({ offer: offer })
        rv = Review.create!(attributes)
        rv.call = self # saves relation in call.review_id
        rv
      end
    end

  end

end
