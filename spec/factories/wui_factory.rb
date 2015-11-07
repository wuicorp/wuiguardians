FactoryGirl.define do
  factory :wui do
    wui_type 'crash'
    status 'sent'
    association :user, factory: :user

    association :vehicle, factory: :vehicle

    factory :wui_with_position do
      latitude 0.0
      longitude 0.0
    end
  end
end
