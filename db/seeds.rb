require 'faker'

Rails.logger.debug "Destroying Invitations..."
Invitation.destroy_all

Rails.logger.debug "Destroying Invitees..."
Invitee.destroy_all

Rails.logger.debug "Destroying Events..."
Event.destroy_all

Rails.logger.debug "Destroying Users..."
User.destroy_all

Rails.logger.debug "Creating Users"
5.times do
  User.create!(
    email: Faker::Omniauth.google[:info][:email],
    first_name: Faker::Omniauth.google[:info][:first_name],
    last_name: Faker::Omniauth.google[:info][:last_name],
    password: '123456'
  )
end

users = User.all

Rails.logger.debug "Creating Events..."
20.times do
  rand_date = ((Date.current - 10) + rand((Date.current + 30) - (Date.current - 10)))

  Event.create!(
    title: Faker::Lorem.sentence(word_count: rand(3..8)),
    description: Faker::Lorem.paragraph,
    date: rand_date,
    time: 60,
    creator: users.sample
  )
end

Rails.logger.debug "Creating Invitees..."
25.times do
  user = User.order("RANDOM()").first
  event = Event.where.not(creator: user).order("RANDOM()").first
  Invitee.create!(
    user:,
    event:
  )
end

Rails.logger.debug "Finished seeding!"
