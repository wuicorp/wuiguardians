FactoryGirl.define do
  factory :wui do
    wui_type 'crash'
    status 'sent'
    association :user, factory: :user

    vehicle_identifier '1234AAA'

    factory :wui_with_position do
      latitude 0.0
      longitude 0.0
    end
  end
end
