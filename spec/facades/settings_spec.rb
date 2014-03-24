require 'spec_helper'

describe Settings do
  before(:each) do
    PlatformSettings.stub(:last) { double(platform_fee: 10) }
  end

  context 'when setting exists' do
    it 'should return setting value' do
      expect(Settings.platform_fee).to eq 10
    end
  end

  context 'when setting does not exist' do
    it 'should raise error' do
      expect { Settings.fake_setting }.to raise_error
    end
  end
end
