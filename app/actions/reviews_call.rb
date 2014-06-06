class ReviewsCall
  include LightService::Organizer

  def self.for(id, user, review)
    with(id: id, user: user, review: review).reduce [
      LookupCall,
      DetermineReviewable,
      ReviewCall
    ]
  end

  class LookupCall
    include LightService::Action

    executed do |context|
      id = context.fetch :id
      if id.is_a? Call
        call = id
      else
        begin
          call = Call.find id
        rescue => e
          context.fail! e
        end
      end
      context[:call] = call
    end
  end

  class DetermineReviewable
    include LightService::Action

    executed do |context|
      call = context.fetch :call
      user = context.fetch :user
      context.fail! 'This call cannot be reviewed!' unless call.can_be_reviewed?
      context.fail! 'You cannot review this call!' unless user == call.seeker
    end
  end

  class ReviewCall
    include LightService::Action

    executed do |context|
      call = context.fetch :call
      review = context.fetch :review
      begin
        call.create_review(review)
        context[:call] = call
      rescue => e
        context.fail! e.message
      end
    end
  end
end
