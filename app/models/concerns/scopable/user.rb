module Scopable
  module User
    extend ActiveSupport::Concern

    included do
      scope :experts, -> { where linkedin_network: { :$gte => ::User.required_connections }, wants_to_be_an_expert: true }
      scope :confirmed, -> { where confirmation_sent_at: { :$lte => Time.now } }
      scope :with_languages, -> languages { any_in languages: languages }
      scope :with_continent, -> continents { any_in continent: continents }
      scope :with_slug, -> slug { any_of({ slug: slug }, { lower_slug: slug }) }
      scope :rates_between, -> lower, upper { where :'offers.rate' => { :$lte => upper, :$gte => lower } }
      scope :available, -> { where availabilities: { :$ne => [] } }
      scope :experiences_between, -> lower, upper { where :'offers.experience' => { :$lte => upper, :$gte => lower } }
      scope :with_group, -> group { where(:'offers.group_id' => group.id) }
      scope :with_email, -> email { any_of({ email: email }, { contact_email: email }, { :'user_linkedin_connection.email' => email }) }
    end
  end
end
