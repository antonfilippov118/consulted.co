module Scopable
  module User
    extend ActiveSupport::Concern

    included do
      scope :experts, -> { where linkedin_network: { :$gte => ::User.required_connections }, wants_to_be_an_expert: true }
      scope :confirmed, -> { where confirmation_sent_at: { :$lte => Time.now } }
      scope :with_languages, -> languages { where languages: { :$all => languages } }
      scope :with_slug, -> slug { where slug: slug }
      scope :rates_between, -> lower, upper { where :'offers.rate' => { :$lte => upper, :$gte => lower } }
      scope :experiences_between, -> lower, upper { where :'offers.experience' => { :$lte => upper, :$gte => lower } }
      scope :on_day, -> day { where :'availabilities.day' => day, :'availabilities.recurring' => true }
      scope :available_from, -> starts { where :'availabilities.starts' => { :$gte => starts } }
      scope :available_to, -> ends { where :'availabilities.ends' => { :$lte => ends } }
      scope :available_on, -> date { where :'availabilities.starts' => { :$gte => date } }
      scope :with_hours_from, -> starts { where :'availabilities.start_hour' => { :$gte => starts } }
      scope :with_hours_to, -> to { where :'availabilities.end_hour' => { :$gte => to } }
      scope :with_group, -> group { where(:'offers.group_id' => group.id) }
    end
  end
end
