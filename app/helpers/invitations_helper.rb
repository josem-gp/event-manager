module InvitationsHelper
  def show_invitees?(event, is_an_invitee)
    current_user_is_creator?(event) || is_an_invitee
  end

  def invitation_expired?(invitation)
    invitation.expired
  end

  private

  def current_user_is_creator?(event)
    current_user == event.creator
  end
end
