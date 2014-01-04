class EmailValidator < ActiveModel::Validator
  def validate(record)
    if (regexp =~ record.email).nil?
      record.errors.add :email, options[:message] || "is not properly formatted!"
    end
  end

private
  def regexp
    /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end
