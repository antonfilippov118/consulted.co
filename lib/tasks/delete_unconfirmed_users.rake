namespace :unconfirmed_users do

  desc 'deletes unconfirmed users'
  task purge: :environment do
    DeletesUnconfirmedUser.after 48.hours
  end
end
