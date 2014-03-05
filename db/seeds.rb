# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# TODO: better to use factories or gem like seedbank

images = %w(alex.jpg florian.jpg sebastian.jpg)

10.times do |time|
  user = User.new
  user.email = "user#{time}@example.com"
  user.name = "Firstname#{time} Lastname#{time}"
  user.password = '123456'
  user.password_confirmation = '123456'
  user.linkedin_network = 1
  user.profile_image = File.read(Rails.root.join('app', 'assets', 'images', images.sample))
  user.save

  3.times do |t|
    company = User::LinkedinCompany.new
    company.user = user
    company.name = "Company_#{time}_#{t}"
    company.position = 'Director'
    company.save
  end
end
