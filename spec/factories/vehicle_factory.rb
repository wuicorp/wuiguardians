FactoryGirl.define do
  factory :vehicle do
    identifier Faker::Number.number(7)
  end
end
