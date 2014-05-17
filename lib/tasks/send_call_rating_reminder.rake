namespace :calls do
  desc 'sends a reminder to a meeting\'s seeker to rate the meeting'
  task :remind_rating do
    SendCallRatingReminder.do
  end
end
