# encoding: utf-8
require 'spec_helper'

describe Favorites do
  before(:each) do
    Favorites.delete_all
    User.delete_all

    10.times do |t|
      user = User.create! name: "Florian#{t}", email: "user#{t}@example.com", password: 'tester', password_confirmation: 'tester', linkedin_network: 1
      # user 4 is not confirmed
      if t == 4
        user.confirm!
      end
      if t < num
        users << user
      end
    end
  end

  it 'should be creatable' do
    favorite = Favorite.new(user_id: 1, fav_user_id: 2)
    expect do
      favorite.save!
    end.not_to raise_error
  end

  it 'should have a confirmed fav_user' do
    favorite = Favorite.new(user_id: 1, fav_user_id: 4)
    expect do
      favorite.save!
    end.to raise_error
  end

  it 'should have a user_id and a fav_user_id' do

    favorite = Favorite.new(user_id: 1, fav_user_id: null)

    expect do
      favorite.has_both_ids?
    end.to be_false

  end

end
