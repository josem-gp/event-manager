FactoryBot.define do
  factory :user do
    email { Faker::Omniauth.google[:info][:email] }
    first_name { Faker::Omniauth.google[:info][:first_name] }
    last_name { Faker::Omniauth.google[:info][:last_name] }
    password { 'password' }
  end
end
