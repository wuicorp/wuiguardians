FactoryGirl.define do
  factory :flag do
    longitude '0.0'
    latitude '0.0'
    radius '10'
    association :user, factory: :user
  end
end
