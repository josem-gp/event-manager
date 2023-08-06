class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  # Fetch events user created and events accepted by the user in the current week
  def index
    return unless current_user

    events_as_creator = current_user.created_events.where(date: Date.current.in_time_zone(ENV.fetch('TZ',
                                                                                                    nil)).all_week)
    events_as_invitee = current_user.events.where(date: Date.current.in_time_zone(ENV.fetch('TZ', nil)).all_week)

    @all_events = events_as_creator + events_as_invitee
  end
end
