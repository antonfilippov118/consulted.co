module Sluggable
  module User
    extend ActiveSupport::Concern

    def default_slug
      slug = name.gsub ' ', ''
      slug = email.downcase.split('@').first if slug == ''
      slug = slug.downcase
      slug ||= ''
      i = 1
      while ::User.with_slug(slug).exists?
        slug += "#{i}"
        i += 1
      end
      slug
    end

    included do
      field :slug, type: String
      field :lower_slug, type: String
      before_save do
        self.slug = default_slug if self.slug.nil?
      end
    end
  end

  module Offer
    extend ActiveSupport::Concern
    def slug_url
      "#{slug}-with-#{expert.lower_slug}"
    end

    included do
      field :url
      before_save do
        self.url = slug_url
      end
    end
  end
end
