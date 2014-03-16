FactoryGirl.define do
  sequence :email do |n|
    "somebody#{n}@example.com"
  end

  sequence :name do |n|
    "Firstname#{n} Lastname#{n}"
  end
end
