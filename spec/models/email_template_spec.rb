require 'spec_helper'

describe EmailTemplate do
  describe 'validations' do
    it { should validate_presence_of :subject }
    it { should validate_presence_of :html_version }
    it { should validate_presence_of :text_version }
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end
end
