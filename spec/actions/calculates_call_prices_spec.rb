require 'spec_helper'

class CalculatesCallPrices
  include LightService::Organizer
  def self.for(call)
    with(call: call).reduce [
      CalculatePriceWithFee,
      CalculatePriceWithoutFee
    ]
  end

  class CalculatePriceWithFee
    include LightService::Action

    executed do |context|
      call =  context.fetch :call
      offer = call.offer
      if call.length == 60
        context[:price_incl_fee] = offer.rate.to_f
        next
      end
      context[:price_incl_fee] = (offer.rate.to_f / 60 * call.length).round 2
    end
  end

  class CalculatePriceWithoutFee
    include LightService::Action

    executed do |context|
      call =  context.fetch :call
      offer =  call.offer
      context[:price_excl_fee] = ((offer.rate - offer.rate * percentage) / 60 * call.length).round 2
    end

    private

    def self.percentage
      Settings.platform_fee.to_f / 100
    end
  end
end

describe CalculatesCallPrices do
  let(:action) { CalculatesCallPrices }
  before(:each) do
    Call.delete_all
  end

  describe 'calculating for the seeker' do
    {
      30 => {
        555 => 277.50,
        666 => 333.00,
        1333 => 666.50,
        712 => 356.00,
        317 => 158.50
      },
      45 => {
        555 => 416.25,
        666 => 499.50,
        1333 => 999.75,
        4765 => 3573.75,
        9999 => 7499.25
      },
      60 => {
        555 => 555.00,
        666 => 666.00,
        1333 => 1333.00,
        4765 => 4765.00,
        9999 => 9999.00
      },
      90 => {
        323 => 484.50,
        922 => 1383.00,
        741 => 1111.50,
        3333 => 4999.50,
        8856 => 13284.00
      },
      120 => {
        666 => 1332.00,
        117 => 234.00
      }
    }.each_pair do |length, base_price|
      describe "for #{length} minutes" do
        base_price.each_pair do |base, price|
          it "should calculate the price with the fee for a call for a rate of #{base}" do
            offer = expert.offers.create group: group, rate: base
            c = Call.create offer: offer, length: length, expert: expert, seeker: seeker, active_from: Time.now
            result = action.for c

            expect(result.success?).to be_true
            expect(result.fetch(:price_incl_fee)).to eql price
          end
        end
      end
    end
  end

  describe 'calculating what the expert gets' do
    {
      30 => {
        555 => 235.88,
        666 => 283.05,
        1333 => 566.53,
        712 => 302.60,
        317 => 134.73
      },
      45 => {
        555 => 353.81,
        666 => 424.58,
        1333 => 849.79,
        4765 => 3037.69,
        9999 => 6374.36
      },
      60 => {
        555 => 471.75,
        666 => 566.10,
        1333 => 1133.05,
        4765 => 4050.25,
        9999 => 8499.15
      },
      90 => {
        323 => 411.83,
        922 => 1175.55,
        741 => 944.78,
        3333 => 4249.58,
        8856 => 11291.40
      },
      120 => {
        666 => 1132.20,
        117 => 198.90
      }
    }.each_pair do |length, base_price|
      describe "for #{length} minutes" do
        base_price.each_pair do |base, price|
          it "should calculate the price without the fee for a call for a rate of #{base}" do
            offer = expert.offers.create group: group, rate: base
            c = Call.create offer: offer, length: length, expert: expert, seeker: seeker, active_from: Time.now
            result = action.for c

            expect(result.success?).to be_true
            expect(result.fetch(:price_excl_fee)).to eql price
          end
        end
      end
    end
  end

  def expert
    @expert = @expert || User.create(valid_params)
    @expert
  end

  def group
    Group.create name: 'Finance'
  end

  def seeker
    User.create valid_params.merge email: 'seeker@consulted.co'
  end
end
