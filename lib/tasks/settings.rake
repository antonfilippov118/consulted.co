namespace :settings do
  desc 'Creates the initial platfrom settings'
  task create: :environment do
    PlatformSettings.create
  end
end