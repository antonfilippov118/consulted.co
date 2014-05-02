module CallsHelper
  def partner_for(call)
    person = [call.seeker, call.expert].select { |user| user.id != @user.id }
    person.first.name
  end

  def call_status(call)
    if seeker? call
      seeker_status.fetch call.status
    else
      expert_status.fetch call.status
    end
  end

  def pending?(call)
    call.status == Call::Status::REQUESTED
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

  def seeker_status
    {
      Call::Status::REQUESTED => 'Requested',
      Call::Status::ACTIVE => 'Scheduled',
      Call::Status::CANCELLED => 'Cancelled',
      Call::Status::DECLINED => 'Declined'
    }
  end

  def expert_status
    {
      Call::Status::REQUESTED => 'Offered',
      Call::Status::ACTIVE => 'Scheduled',
      Call::Status::CANCELLED => 'Cancelled'
    }
  end

  def expert_request_status
    {
      Call::Status::REQUESTED => 'Pending your confirmation',
      Call::Status::ACTIVE => 'Active',
      Call::Status::CANCELLED => 'Cancelled'
    }
  end

  def seeker_request_status
    {
      Call::Status::REQUESTED => 'Awaiting confirmation',
      Call::Status::ACTIVE => 'Active',
      Call::Status::CANCELLED => 'Cancelled'
    }
  end

end
