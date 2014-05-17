namespace :calls do
  desc 'auto declines calls which the expert does not decline'
  task decline: :environment do
    DeclinePendingCalls.older_than 24.hours
  end
end
