class Event < ApplicationRecord
  # Associations
  belongs_to :creator, class_name: "User", inverse_of: :created_events
end
