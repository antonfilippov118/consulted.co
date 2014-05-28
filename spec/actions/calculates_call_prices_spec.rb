require 'spec_helper'

class CalculatesCallPrices
  include LightService::Organizer
  def self.for(call)
    with(call: call).reduce [
      CalculatePriceWithFee
    ]
  end

  class CalculatePriceWithFee
    include LightService::Action

    executed do |context|
      context[:price_incl_fee] = 416.66
    end
  end
end

describe CalculatesCallPrices do
  let(:action) { CalculatesCallPrices }
  {
    45 => {
      555.55 => 416.66
    }
  }.each_pair do |length, base_price|
    describe "for #{length} minutes" do
      base_price.each_pair do |base, price|
        it 'can calculate the price with the fee for a call' do
          expert.offers.first.update_attribute :rate, base
          c = Call.create offer: expert.offers.first, length: length, expert: expert, seeker: seeker, active_from: Time.now
          result = action.for c

          expect(result.success?).to be_true
          expect(result.fetch(:price_incl_fee)).to eql price
        end
      end
    end
  end

  def expert
    @expert = @expert || User.create(valid_params)
    @expert.offers.create group: group, rate: 3000
    @expert
  end

  def group
    Group.create name: 'Finance'
  end

  def seeker
    User.create valid_params.merge email: 'seeker@consulted.co'
  end
end
