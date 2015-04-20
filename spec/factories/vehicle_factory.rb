FactoryGirl.define do
  factory :vehicle do
    sequence(:identifier) { |n| "#{n}CMZ" }
  end
end
