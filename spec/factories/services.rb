FactoryBot.define do
  factory :service do
    association :category
    sequence(:title) { |n| "Service #{n}" }
    description { Faker::Lorem.paragraph(sentence_count: 4) }
    price_cents { 100_000 }
    published { true }
    position { 1 }
  end
end
