# encoding: utf-8
require 'spec_helper'

describe User do

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

  context 'being an expert' do
    after(:all) do
      User.delete_all
    end
    it 'should not be an expert right away' do
      expect(User.new.can_be_an_expert?).to be_false
    end

    it 'should have a certain number of contacts in linkedin to be an expert' do
      user = User.create valid_params.merge linkedin_network: 10_000
      user.confirm!
      expect(user.can_be_an_expert?).to be_true
    end

    it 'should be confirmed' do
      user = User.create valid_params.merge linkedin_network: 10_000
      expect(user.can_be_an_expert?).to be_false
    end
  end

  describe '.random' do
    let(:num) { 3 }
    let(:users) { [] }

    context 'when users are exist' do
      before do
        10.times do |t|
          user = User.create! name: "Florian#{t}", email: "user#{t}@example.com", password: 'tester', password_confirmation: 'tester', linkedin_network: 1
          if t < num
            users << user
          end
        end
      end

      it 'should return num of records' do
        User.random(num).count.should eq num
      end

      it 'should return random records' do
        Array.any_instance.stub(:shuffle) { users }

        # NOTE: we can just compare by email as it is a unique field
        User.random(num).map(&:email).should eq users.map(&:email)
      end
    end

    context 'when users are not exist' do
      before do
        User.stub(:criteria) { [] }
      end

      it 'should return empty array if there are no records' do
        User.random(num).count.should eq 0
      end
    end
  end
end
