module Validatable
  module User
    extend ActiveSupport::Concern

    STATUS_LIST = %w(active disabled deactivated)
    ALLOWED_LANGUAGES = %w(spanish english mandarin german arabic)

    def languages_allowed?
      languages.each do |language|
        unless ALLOWED_LANGUAGES.include? language
          errors.add :base, "Language '#{language}'' is not allowed."
        end
      end
      if languages.length > ALLOWED_LANGUAGES.length
        errors.add :base, 'Too many languages!'
      end
    end

    included do
      validate :languages_allowed?
      validates_inclusion_of :timezone, in: ActiveSupport::TimeZone.zones_map(&:name)
      validates_inclusion_of :status, in: STATUS_LIST
      validates_uniqueness_of :slug
      validates_with SlugValidator
    end
  end
end
