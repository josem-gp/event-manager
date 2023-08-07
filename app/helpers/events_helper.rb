module EventsHelper
  # Date and Time Formatting
  def formatted_event_date(date)
    date.strftime('%B %e')
  end

  def event_weekday(date)
    date.strftime('%A')
  end

  def event_time(time)
    time.strftime('%I:%M %p')
  end

  # Name Formatting
  def creator_full_name(creator)
    "#{creator.first_name} #{creator.last_name}"
  end

  def invitee_full_name(invitee_user)
    "#{invitee_user.first_name} #{invitee_user.last_name}"
  end
end
