namespace :admin do
  desc 'Create admin user'
  task create: :environment do
    email = ENV['email'] || 'admin@example.com'
    password = ENV['password'] || 'test1234'

    if Admin.where(email: email).exists?
      puts 'Admin already exists!'
    else
      admin = Admin.create!(
        email: email,
        password: password,
        password_confirmation: password
      )

      AdminMailer.welcome(admin).deliver
    end
  end
end
