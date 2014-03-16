FactoryGirl.define do
  sequence :email do |n|
    "somebody#{n}@example.com"
  end
end
