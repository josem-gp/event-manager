class EventsController < ApplicationController
  before_action :set_new_event, only: %i[new create]
  before_action :find_event_or_redirect, only: :show

  def show
    @is_an_invitee = current_user.an_invitee?(@event)
    @invitation = current_user.received_invitations.find_by(event: @event)
  end

  def new; end

  def create
    if save_event
      redirect_to root_path, notice: t('events.successful_creation')
    else
      flash_errors(@event)
      render :new, status: :unprocessable_entity, content_type: 'text/html'
    end
  end

  private

  def set_new_event
    @event = Event.new
  end

  def find_event_or_redirect
    return if (@event = Event.find_by(id: params[:id]))

    redirect_to root_path, error: t('events.not_found')
  end

  def save_event
    @event.assign_attributes(event_params.except(:invitees_emails))
    @event.creator = current_user

    return false unless @event.save

    # After we save the event, we send the invitations if invitees exist
    return true if event_params[:invitees_emails].blank?

    InvitationService.new(@event, event_params[:invitees_emails]).call
    true
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :invitees_emails)
  end
end
