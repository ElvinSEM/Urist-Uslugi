FactoryBot.define do
  factory :service_request do
    association :service
    association :client, factory: :user
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { "+79990000000" }
    description { Faker::Lorem.paragraph }
    status { :pending }
  end
end
