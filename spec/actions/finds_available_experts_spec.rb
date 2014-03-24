require File.dirname(__FILE__) + '/../spec_helper'

describe FindsAvailableExperts do
  before(:each) do
    Group.delete_all
    User.delete_all
  end

  it 'looks up experts for any given group' do
    group = Group.create name: 'Finance'

    expert = User.create valid_params.merge linkedin_network: 10_000, languages: %w(english mandarin)
    expert.confirm!

    expert.availabilities.create starts: Time.now - 2.hours, ends: Time.now + 2.hours
    expert.offers.create rate: 25, experience: 2, lengths: %w(30 60), group: group

    params = {
      group_id: Group.first.id.to_s
    }

    result = FindsAvailableExperts.for params
    expect(result.success?).to be_true
    expect(result[:experts].length).to eql 1
    expect(result[:experts].first).to eql expert
  end

  it 'should support rate parameters' do
    group = Group.create name: 'Finance'

    expert = User.create valid_params.merge linkedin_network: 10_000, languages: %w(english mandarin)
    expert.confirm!

    expert.availabilities.create starts: Time.now - 2.hours, ends: Time.now + 2.hours
    expert.offers.create rate: 25, experience: 2, lengths: %w(30 60), group: group

    params = {
      group_id: Group.first.id.to_s,
      rate_upper: '20',
      rate_lower: ''
    }

    result = FindsAvailableExperts.for params
    expect(result.success?).to be_true
    expect(result[:experts].length).to eql 0

    params = {
      group_id: Group.first.id.to_s,
      rate_lower: '30',
      rate_upper: ''
    }

    result = FindsAvailableExperts.for params
    expect(result[:experts].length).to eql 0

    params = {
      group_id: Group.first.id.to_s,
      rate_lower: '10',
      rate_upper: '30'
    }

    result = FindsAvailableExperts.for params
    expect(result[:experts].length).to eql 1
  end

  it 'should support experience parameters' do
    group = Group.create name: 'Finance'

    expert = User.create valid_params.merge linkedin_network: 10_000, languages: %w(english mandarin)
    expert.confirm!

    expert.availabilities.create starts: Time.now - 2.hours, ends: Time.now + 2.hours
    expert.offers.create rate: 25, experience: 2, lengths: %w(30 60), group: group

    params = {
      group_id: Group.first.id.to_s,
      experience_upper: '1',
      experience_lower: ''
    }

    result = FindsAvailableExperts.for params
    expect(result[:experts].length).to eql 0

    params = {
      group_id: Group.first.id.to_s,
      experience_upper: '5',
      experience_lower: ''
    }

    result = FindsAvailableExperts.for params
    expect(result[:experts].length).to eql 1
  end

  it 'should filter experts by a given date' do
    group = Group.create name: 'Finance'

    expert = User.create valid_params.merge linkedin_network: 10_000, languages: %w(english mandarin)
    expert.confirm!

    expert.availabilities.create starts: Time.now - 2.hours, ends: Time.now + 2.hours
    expert.offers.create rate: 25, experience: 2, lengths: %w(30 60), group: group

    params = {
      group_id: Group.first.id.to_s,
      date: 'on',
      time: 'on'
    }

    result = FindsAvailableExperts.for params
    expect(result[:experts].length).to eql 1

    params[:date] = Date.tomorrow.strftime '%Y-%m-%d'

    result = FindsAvailableExperts.for params
    expect(result[:experts].length).to eql 0
  end

  it 'should allow for a time filter' do
    group = Group.create name: 'Finance'

    expert = User.create valid_params.merge linkedin_network: 10_000, languages: %w(english mandarin)
    expert.confirm!

    starts = DateTime.now.change(hour: 12, minute: 0)
    ends   = starts + 2.hours

    expert.availabilities.create starts: starts, ends: ends
    expert.offers.create rate: 25, experience: 2, lengths: %w(30 60), group: group

    params = {
      group_id: Group.first.id.to_s,
      time: 'on',
      date: 'on'
    }

    result = FindsAvailableExperts.for params
    expect(result[:experts].length).to eql 1

    params[:time] = '10_14'

    result = FindsAvailableExperts.for params
    expect(result[:experts].length).to eql 1

    params[:time] = '20'

    result = FindsAvailableExperts.for params
    expect(result[:experts].length).to eql 0

  end

  it 'should not include the current_user' do
    group = Group.create name: 'Finance'

    expert = User.create valid_params.merge linkedin_network: 10_000, languages: %w(english mandarin)
    expert.confirm!

    starts = DateTime.now.change(hour: 12, minute: 0)
    ends   = starts + 2.hours

    expert.availabilities.create starts: starts, ends: ends
    expert.offers.create rate: 25, experience: 2, lengths: %w(30 60), group: group

    params = {
      group_id: group.id.to_s
    }
    result = FindsAvailableExperts.for params, expert

    expect(result[:experts].length).to eql 0
  end
end
