FactoryGirl.define do
  factory :wui do
    wui_type :crash
    status :pending
    association :user, factory: :user
    association :vehicle, factory: :vehicle
  end
end
