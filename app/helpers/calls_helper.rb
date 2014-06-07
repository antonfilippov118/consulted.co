module CallsHelper
  def partner_for(call)
    person = [call.seeker, call.expert].select { |user| user.id != @user.id }
    person.first
  end

  def name_link(call)
    user = partner_for call
    if user.expert? && seeker?(call)
      link_to user.name, expert_page(user), target: '_blank'
    else
      user.name
    end
  end

  def call_status(call)
    if seeker? call
      'Requested'
    else
      'Offered'
    end
  end

  def pending?(call)
    call.status == Call::Status::REQUESTED
  end

  def active?(call)
    call.status == Call::Status::ACTIVE
  end

  def cancellable?(call)
    call.status == Call::Status::ACTIVE || call.status == Call::Status::REQUESTED
  end

  def seeker?(call)
    call.seeker == @user
  end

  def expert?(call)
    call.expert == @user
  end

  def call_class(call)
    return 'pending' if pending?(call)
    ''
  end

  def request_status(call)
    if seeker? call
      seeker_request_status.fetch call.status
    else
      expert_request_status.fetch call.status
    end
  end

  def expert_request_status
    {
      Call::Status::REQUESTED => 'Pending your confirmation',
      Call::Status::ACTIVE => 'Scheduled',
      Call::Status::CANCELLED => 'Cancelled',
      Call::Status::DECLINED => 'Declined',
      Call::Status::COMPLETED => 'Completed'
    }
  end

  def seeker_request_status
    {
      Call::Status::REQUESTED => 'Awaiting confirmation',
      Call::Status::ACTIVE => 'Scheduled',
      Call::Status::CANCELLED => 'Cancelled',
      Call::Status::DECLINED => 'Cancelled',
      Call::Status::COMPLETED => 'Completed'

    }
  end

end
