require 'faker'

def create_fake_data(user)
  Rails.logger.debug { "Creating data for #{user.email}..." }

  Rails.logger.debug "Creating Events..."
  10.times do
    rand_date = ((Date.current - 10) + rand((Date.current + 30) - (Date.current - 10)))

    Event.create!(
      title: Faker::Lorem.sentence(word_count: rand(3..8)),
      description: Faker::Lorem.paragraph,
      date: rand_date,
      time: 60,
      creator: user
    )
  end

  Rails.logger.debug "Creating Invitees..."
  15.times do
    user = User.order("RANDOM()").first
    event = Event.where.not(creator: user).order("RANDOM()").first
    Invitee.create!(
      user:,
      event:
    )
  end
end

Rails.logger.debug "Destroying Invitations..."
Invitation.destroy_all

Rails.logger.debug "Destroying Invitees..."
Invitee.destroy_all

Rails.logger.debug "Destroying Events..."
Event.destroy_all

Rails.logger.debug "Destroying Users..."
# User.destroy_all

Rails.logger.debug "Creating Users"
5.times do
  User.create!(
    uid: Faker::Omniauth.google[:uid],
    email: Faker::Omniauth.google[:info][:email],
    first_name: Faker::Omniauth.google[:info][:first_name],
    last_name: Faker::Omniauth.google[:info][:last_name]
  )
end

users = User.all

users.each do |user|
  create_fake_data(user)
end

Rails.logger.debug "Finished seeding!"
