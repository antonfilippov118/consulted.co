class StaticController < ApplicationController
  layout 'static'

  %w(
    confidentiality
    make_the_most
    about_us
    privacy
    case_studies
    terms
  ).each do |method_name|
    define_method(method_name) do
      title! "#{titles.fetch method_name.to_sym} - Consulted"
    end
  end

  def titles
    {
      confidentiality: 'Confidentiality & conduct',
      make_the_most: 'Make the most of it',
      about_us: 'About us',
      privacy: 'Privacy policy',
      case_studies: 'Case studies',
      terms: 'Terms & conditions'
    }
  end
end
