module Indexable
  module User
    extend ActiveSupport::Concern

    included do
      index({ email: 1, contact_email: 1 }, { unique: true })
    end
  end
end
