# encoding: utf-8

FactoryGirl.create :platform_settings

profile_images = %w(alex.jpg florian.jpg sebastian.jpg)

10.times do |time|
  profile_image = File.read(
    Rails.root.join('app', 'assets', 'images', profile_images.sample)
  )
  user = FactoryGirl.create :expert_user, profile_image: profile_image

  3.times do |t|
    FactoryGirl.create :company, user: user, name: "Company##{t} of #{user.name}", position: 'Director'
  end
end

# Seeding email templates

FactoryGirl.create :email_template, :confirmation_instructions
FactoryGirl.create :email_template, :reset_password_instructions
FactoryGirl.create :email_template, :admin_welcome
FactoryGirl.create :email_template, :request_notification
FactoryGirl.create :email_template, :request_cancellation
