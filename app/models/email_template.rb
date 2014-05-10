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

  def sender
    from || Settings.email_default_from
  end

  private

  def template(version)
    @template = Liquid::Template.parse(acquire(version))
  end

  def acquire(version)
    if version == :html_version
      mail_template send(version)
    else
      send version
    end
  end

  def mail_template(content)
    static_template.gsub '##CONTENT##', content
  end

  def static_template
    File.read(mail_path)
  end

  def mail_path
    Rails.root.join 'app', 'assets', 'templates', 'mail.html'
  end
end
