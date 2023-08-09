FactoryBot.define do
  factory :event do
    association :creator, factory: :user

    title { Faker::Lorem.sentence(word_count: rand(3..8)) }
    description { Faker::Lorem.paragraph }
    date { Time.zone.today }
    time { 60 }
  end
end
