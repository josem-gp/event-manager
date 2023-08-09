FactoryBot.define do
  factory :invitee do
    association :user
    association :event
  end
end
