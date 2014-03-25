require 'spec_helper'

describe PlatformSettings do
  describe 'validations' do
    it { should validate_numericality_of(:platform_fee).to_allow(greater_than_or_equal_to: 1).less_than_or_equal_to(100) }
    it { should validate_numericality_of(:cancellation_fee).to_allow(greater_than_or_equal_to: 1).less_than_or_equal_to(100) }
    it { should validate_numericality_of(:call_dispute_period).to_allow(greater_than_or_equal_to: 0) }
    it { should validate_numericality_of(:block_time).to_allow(greater_than: 0) }
    it { should validate_numericality_of(:session_timeout).to_allow(greater_than_or_equal_to: 0) }
  end

  describe 'callbacks' do
    describe '.before_validation' do
      let!(:platform_settings) { create(:platform_settings) }
      let(:new_platform_settings) { build(:platform_settings) }

      it 'should ensure has only one record' do
        expect { new_platform_settings.save! }.to raise_error
      end
    end
  end
end
