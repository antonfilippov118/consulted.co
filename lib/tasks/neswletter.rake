namespace :newsletter do
  desc 'Updates the newsletter entries'
  task update: :environment do
    User.all.each do |user|
      if user.newsletter?
        update! user
      else
        remove! user
      end
    end
  end

  def update!(user)
    newsletter.email = user.email
    newsletter.send!
  end

  def remove!(user)
    newsletter.email = user.email
    newsletter.remove!
  end

  def newsletter
    @newsletter ||= Newsletter.new list_name: 'Consulted Newsletter'
  end
end
