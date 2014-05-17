namespace :calls do
  desc 'sends reminders to the meeting partner before the meeting'
  task remind: :environment do
    SendCallReminders.do
  end
end
