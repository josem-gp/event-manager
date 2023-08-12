require 'faker'

Rails.logger.info "Destroying Seeds..."
Invitation.destroy_all

Invitee.destroy_all

Event.destroy_all

User.destroy_all

Rails.logger.info "Creating Seeds"
4.times do
  user = User.create!(
    email: Faker::Omniauth.google[:info][:email],
    first_name: Faker::Omniauth.google[:info][:first_name],
    last_name: Faker::Omniauth.google[:info][:last_name],
    password: '123456'
  )

  Rails.logger.info "\nCreated user. The data to login with this user is the following:"
  Rails.logger.info "User email: #{user.email}"
  Rails.logger.info "User password: #{user.password}"
end

users = User.all

10.times do
  # Get a random date within the current week
  start_of_week = Date.current.beginning_of_week
  random_days_within_week = rand(7)
  random_date_within_week = start_of_week + random_days_within_week

  random_hour = rand(24)
  random_minute = rand(60)
  random_datetime = DateTime.new(
    random_date_within_week.year,
    random_date_within_week.month,
    random_date_within_week.day,
    random_hour,
    random_minute
  )

  Event.create!(
    title: Faker::Lorem.sentence(word_count: rand(3..8)),
    description: Faker::Lorem.paragraph,
    date: random_datetime,
    time: 60,
    creator: users.sample
  )
end

6.times do
  event = Event.order("RANDOM()").first
  recipient = User.where.not(id: event.creator.id).order("RANDOM()").first
  invitation = Invitation.create!(
    sender: event.creator,
    event:,
    recipient:,
    url: "#{ENV.fetch('APP_URL', 'http://localhost:3000')}/events/#{event.id}"
  )

  Rails.logger.info "\nTo check invitations out:"
  Rails.logger.info "Logging in as this user: #{recipient.email}"
  Rails.logger.info "Go to the url: #{invitation.url}"
end

Rails.logger.info "Finished seeding!"
