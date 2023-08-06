class Event < ApplicationRecord
  # Associations
  belongs_to :creator, class_name: "User", inverse_of: :created_events
  has_many :invitees, dependent: :destroy
  has_many :users, through: :invitees
end
