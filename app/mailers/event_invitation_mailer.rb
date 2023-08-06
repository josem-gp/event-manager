class EventInvitationMailer < ApplicationMailer
  def send_invitation
    @recipient = params[:recipient]
    @sender = params[:sender]
    @url = params[:url]

    mail(to: @recipient.email, subject: t('invitations.greetings'))
  end
end
