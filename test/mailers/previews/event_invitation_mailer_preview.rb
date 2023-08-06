# Preview all emails at http://localhost:3000/rails/mailers/event_invitation_mailer
require 'faker'

class EventInvitationMailerPreview < ActionMailer::Preview
  def send_invitation
    recipient = User.new(
      email: Faker::Omniauth.google[:info][:email],
      first_name: Faker::Omniauth.google[:info][:first_name],
      last_name: Faker::Omniauth.google[:info][:last_name],
      password: '123456'
    )
    sender = User.new(
      email: Faker::Omniauth.google[:info][:email],
      first_name: Faker::Omniauth.google[:info][:first_name],
      last_name: Faker::Omniauth.google[:info][:last_name],
      password: '123456'
    )
    event = Event.new(
      title: Faker::Lorem.sentence(word_count: rand(3..8)),
      description: Faker::Lorem.paragraph,
      date: ((Date.current - 10) + rand((Date.current + 30) - (Date.current - 10))),
      time: 60,
      creator: sender
    )
    invitation = Invitation.new(recipient: recipient, sender: sender, event: event, url: "#{ENV['APP_URL']}/events/135")

    EventInvitationMailer.with(recipient: recipient, sender: sender, url: invitation.url).send_invitation
  end
end
