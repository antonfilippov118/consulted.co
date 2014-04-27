class EmailTemplate
  include Mongoid::Document
  include Validatable::EmailTemplate

  field :name, type: String
  field :subject, type: String
  field :from, type: String
  field :html_version, type: String
  field :text_version, type: String

  index({ name: 1 }, { unique: true, name: 'name_index' })

  attr_reader :template

  def render(options = {}, format = 'html')
    version = "#{format}_version".to_sym
    template(version).render options
  end

  private

  def template(version)
    @template = Liquid::Template.parse(send(version))
  end
end
