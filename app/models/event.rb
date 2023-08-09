class Event < ApplicationRecord
  # Associations
  belongs_to :creator, class_name: "User", inverse_of: :created_events
  has_many :invitees, dependent: :destroy
  has_many :users, through: :invitees

  # Validations
  validates :title, :date, :time, presence: true

  # Callbacks
  # We will only create events as per specification of the project
  after_validation :single_event_per_date_and_time, on: :create

  private

  # Does not allow the creator to create another event during the same day and timeframe
  def single_event_per_date_and_time
    return if errors.present?

    end_time = date + time.minutes

    existing_events = Event.where(
      creator:
    ).where("(date, date + INTERVAL '60 MINUTE') OVERLAPS (?, ?)", date, end_time)

    errors.add(:base, "Another event already exists at this date and time") unless existing_events.empty?
  end
end
