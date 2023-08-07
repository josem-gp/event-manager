module InvitationsHelper
  def show_invitees?
    current_user_is_creator?(@event) || @is_an_invitee
  end

  def invitation_expired?
    @invitation.expired
  end

  private

  def current_user_is_creator?(event)
    current_user == event.creator
  end
end
