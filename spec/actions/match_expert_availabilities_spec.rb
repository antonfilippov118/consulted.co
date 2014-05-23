require 'spec_helper'

describe MatchExpertAvailabilities do
  let(:action) { MatchExpertAvailabilities }
  context 'should filter a given set of experts by date of their availability' do
    it 'should keep experts which provide an availability on a given day' do
      expert.availabilities.create start: Time.now - 2.hours, end: Time.now + 2.hours
      result = action.for group: group, days: [Time.now.strftime(format)], experts: User.all
      expect(result.success?).to be_true
      experts = result.fetch :experts
      expect(experts.length).to eql 1
    end

    it 'should filter experts which do not provide availabilities on the given days' do
      expert.availabilities.create start: Time.now + 2.days, end: Time.now + 50.hours
      result = action.for group: group, days: [Time.now.strftime(format)], experts: User.all
      expect(result.success?).to be_true
      experts = result.fetch :experts
      expect(experts.length).to eql 0
    end
  end

  def expert
    @expert ||= User.create valid_params.merge start_delay: 0, break: 0
    @expert.offers.create group: group, lengths: %w(30 60 45), rate: 300, experience: 10, description: 'foo'
    @expert
  end

  def user
    @user ||= User.create valid_params.merge email: 'floriankraft@consulted.co'
  end

  def group
    @group ||= Group.create name: 'finance'
  end

  def format
    '%Y-%m-%d'
  end
end
