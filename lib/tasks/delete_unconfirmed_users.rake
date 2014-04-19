namespace :unconfirmed_users do

  desc 'deletes unconfirmed users'
  task purge: :environment do
    DeletesUnconfirmedUser.after 72.hours
  end
end
