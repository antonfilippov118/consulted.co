namespace :calls do
  desc 'completes past calls'
  task complete: :environment do
    CompletesCalls.do
  end
end
