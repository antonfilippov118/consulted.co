# encoding: utf-8

# email validator class for validating emails, the weak checking
# is intended, as the user has to confirm his email anyway
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if (regexp =~ value).nil?
      record.errors.add attribute, options[:message] || 'is not properly formatted!'
    end
  end

  private

  def regexp
    /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end
