FactoryGirl.define do
  factory :wui do
    wui_type 'crash'
    status 'sent'
    association :user, factory: :user
    association :vehicle, factory: :vehicle
  end
end
