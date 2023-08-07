module UsersHelper
  def invited?(event)
    current_user.received_invitations.not_expired.where(event:).any?
  end
end
