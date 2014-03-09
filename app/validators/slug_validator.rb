class SlugValidator < ActiveModel::Validator
  def validate(user)
    forbidden   = forbidden_words.include? user.slug
    application = application_words.include? user.slug

    if forbidden || application
      user.errors.add :slug, 'is not an allowed value'
    end

    if contains_invalid_characters? user.slug
      user.errors.add :slug, 'cannot contain the given characters!'
    end
  end

  private

  def forbidden_words
    []
  end

  def application_words
    # TODO: this is magic, clean that up ... a bit
    internal_routes = Rails.application.routes.routes.map { |r| r.path.spec.to_s.split('/').third.try(:gsub, /\(.*\)/, '') } .compact.uniq
    standard = internal_routes + %w(admin)
    js       = standard.map { |route| "#{route}.js" }
    json     = standard.map { |route| "#{route}.json" }
    standard + js + json
  end

  def contains_invalid_characters?(slug)
    regexp = /:|\/|\?|\#|\[|\]|\@|\!|\$|\&|\'|\(|\)|\*|\+|\,|\;|\=|\"|\s/
    !(slug =~ regexp).nil?
  end
end
