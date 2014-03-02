class DeletesUnconfirmedUser
  include LightService::Organizer

  def self.after(time)
    with(time: time).reduce [
      FindUsers,
      DeleteUsers
    ]
  end

  class FindUsers
    include LightService::Action
    executed do |context|
      time  = context.fetch :time
      users = User.where confirmation_sent_at: { :'$lte' => Time.now - time }
      context[:users] = users
    end
  end

  class DeleteUsers
    include LightService::Action
    executed do |context|
      users = context.fetch :users
      users.delete_all
    end
  end
end
