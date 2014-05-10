module Validatable
  module EmailTemplate
    extend ActiveSupport::Concern

    included do
      validates :subject, presence: true
      validates :html_version, presence: true
      validates :text_version, presence: true
      validates :name, presence: true, uniqueness: true
    end
  end
end
