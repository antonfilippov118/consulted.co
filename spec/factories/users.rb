FactoryGirl.define do
  factory :user do
    email
    name
    password '123456'

    trait :confirmed do
      confirmed_at { DateTime.current }
    end
  end

  factory :expert_user, parent: :user do
    confirmed
    linkedin_network 1
  end
end
