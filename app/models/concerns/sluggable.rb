module Sluggable
  module User
    extend ActiveSupport::Concern

    def default_slug
      slug = name.downcase.gsub ' ', '-'
      slug = email.downcase.split('@').first if slug == ''
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
      before_save do
        self.slug = default_slug
      end
    end
  end
end