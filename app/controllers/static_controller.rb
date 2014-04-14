class StaticController < ApplicationController
  layout 'static'

  %w(
    confidentiality
    make_the_most
    about_us
    privacy
    success_stories
    terms
  ).each do |method_name|
    define_method(method_name) {}
  end
end
