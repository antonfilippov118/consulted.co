class FindsTheRightOffer
  include LightService::Organizer

  def self.for(params)
    term, user = [:term, :user].map { |sym| params.fetch sym }
    with(term: term, user: user).reduce [
      SendNotification
    ]
  end

  class SendNotification
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      term = context.fetch :term
      begin
        mailer.find_offer_request(term, user).deliver!
      rescue => e
        context.fail! e.message
      end
    end

    def self.mailer
      ContactMailer
    end
  end
end
