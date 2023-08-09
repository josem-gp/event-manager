FactoryBot.define do
  factory :invitation do
    association :event
    association :sender, factory: :user
    association :recipient, factory: :user

    url { Faker::Internet.url }
    status { 0 }

    trait :accepted do
      status { 1 }
    end
    trait :denied do
      status { 2 }
    end
  end
end
