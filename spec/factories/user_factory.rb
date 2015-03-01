FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password '_secret_'
    role 'user'
  end
end
