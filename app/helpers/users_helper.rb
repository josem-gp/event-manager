module UsersHelper
  def is_invited?
    current_user.received_invitations.not_expired.where(event: @event).any?
  end
end
