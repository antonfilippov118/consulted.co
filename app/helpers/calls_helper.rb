module CallsHelper
  def partner_for(call)
    person = [call.seeker, call.expert].select { |user| user.id != @user.id }
    person.first
  end

  def expert_page(user)
    'https://foo.bar.com'
  end
end
