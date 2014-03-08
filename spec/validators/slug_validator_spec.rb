require File.dirname(__FILE__) + '/../spec_helper'

describe SlugValidator do
  before(:each) do
    User.delete_all
  end
  it 'should pass by default' do
    user = User.new valid_params
    SlugValidator.new.validate user

    expect(user.errors).to be_empty
  end

  it 'should disallow special chars' do
    user = User.new valid_params
    user.slug = '?foo'
    SlugValidator.new.validate user
    expect(user.errors).not_to be_empty
  end

  it 'should not include rails routes' do
    user = User.new valid_params

    routes = Rails.application.routes.routes.map { |r| r.path.spec.to_s.split('/').third.try(:gsub, /\(.*\)/, '') } .compact.uniq
    user.slug = routes.shuffle.take(1).first

    SlugValidator.new.validate user

    expect(user.errors).not_to be_empty
  end

  it 'should not allow the admin section' do
    user = User.new valid_params
    user.slug = 'admin'

    SlugValidator.new.validate user
    expect(user.errors).not_to be_empty
  end

  it 'should not allow spaces in the slug' do
    user = User.new valid_params

    user.slug = 'foo bar'

    SlugValidator.new.validate user
    expect(user.errors).not_to be_empty
  end
end
