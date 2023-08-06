class EventsController < ApplicationController
  before_action :set_new_event, only: %i[new create]

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

  def save_event
    @event.assign_attributes(event_params.except(:invitees_emails))
    @event.creator = current_user

    if @event.save
      @event.send_invitations(event_params[:invitees_emails])
      true
    else
      false
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :invitees_emails)
  end
end
