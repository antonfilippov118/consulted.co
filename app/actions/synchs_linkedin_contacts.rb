class SynchsLinkedin
  include LightService::Organizer

  def self.for(user)
    with(user: user).reduce [
      SynchContactsAction
      SynchNameAction
    ]
  end

  class SynchContactsAction
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      LinkedinSynchro.synch_contacts user
    end
  end

  class SynchNameAction
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      LinkedinSynchro.synch_name user
    end
  end
end
