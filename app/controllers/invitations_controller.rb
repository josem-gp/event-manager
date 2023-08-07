class InvitationsController < ApplicationController
  before_action :find_invitation, only: %i[accept reject]
  before_action :find_event, only: %i[accept reject]

  def accept
    invitee = Invitee.new(user: current_user, event: @event)
    if invitee.save
      @invitation.update(status: :accepted)
      redirect_to event_path(@event), notice: 'Invitation accepted!'
    else
      redirect_to event_path(@event), notice: 'There was a problem accepting the invitation.'
    end
  end

  def reject
    @invitation.update(status: :denied)
    redirect_to event_path(@event), notice: 'Invitation denied.'
  end

  private

  def find_invitation
    @invitation = Invitation.find(params[:id])
  end

  def find_event
    @event = Event.find(params[:event_id])
  end
end
