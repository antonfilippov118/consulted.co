# encoding: utf-8
require 'spec_helper'

describe User do
  let(:user) { create :user }

  it 'has a name' do
    expect do
      User.new name: 'Florian'
    end.not_to raise_error
  end

  [:email].each do |field|
    it { should validate_uniqueness_of field }
  end

  it 'can have a newsletter flag' do
    expect do
      User.new.newsletter = true
    end.not_to raise_error
  end

  it 'has a default profile image' do
    expect { User.new.profile_image }.not_to be_nil
  end

  context 'being an expert' do
    after(:all) do
      User.delete_all
    end
    it 'should not be an expert right away' do
      expect(User.new.can_be_an_expert?).to be_false
    end

    it 'should have a certain number of contacts in linkedin to be an expert' do
      user = User.create valid_params.merge linkedin_network: 10_000
      user.update_attribute :providers, ['linkedin']
      user.confirm!
      expect(user.can_be_an_expert?).to be_true
    end

    it 'should be confirmed' do
      user = User.create valid_params.merge linkedin_network: 10_000
      expect(user.can_be_an_expert?).to be_false
    end
  end

  describe 'validations' do
    it { should validate_inclusion_of(:status).to_allow(User::STATUS_LIST) }
  end

  describe 'slug creation' do
    it 'should create a slug for a new user' do
      user = User.new valid_params

      user.save!

      user = User.first

      expect(user.slug).to eql 'florian'
    end

    it 'should use incrementary initial slugs for users with the same name' do
      User.create! valid_params

      expect(User.first.slug).to eql 'florian'

      User.create! valid_params.merge email: 'florian1@consulted.co'
      expect(User.last.slug).to eql 'florian1'
    end
  end

  describe 'slug creation via omniauth' do
    it 'should correctly create a slug when creating a user via omniauth' do
      user = User.find_for_linkedin_oauth providers: ['linkedin'], uid: 'foo'

      user.assign_attributes valid_params

      user.save!

      user = User.first

      expect(user.slug).to eql 'florian'
    end
  end

  describe 'Country and Subcontinent' do
    it 'should assign regions and subregions for filtering' do
      user = User.new valid_params
      user.country = 'de'

      user.save

      expect(User.first.continent).to eql 'Europe'
      expect(User.first.region).to eql 'Western Europe'
    end
  end

  context 'token for invoice' do
    let(:user) { User.create! valid_params }

    it 'should present after user creation' do
      expect(user.id_for_invoice).not_to be_blank
    end

    it 'should have format like AB1234567' do
      expect(user.id_for_invoice).to match(/^[A-Z]{2}\d{7}$/)
    end
  end
end
