class DisableInvitationJob < ApplicationJob
  queue_as :default

  def perform(invitation)
    invitation.disable_invitation
  end
end
