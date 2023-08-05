class User < ApplicationRecord
  # Associations
  has_many :events_as_creator, foreign_key: :creator_id, class_name: "Event", inverse_of: :creator, dependent: :destroy
  has_many :invitees, dependent: :destroy
  has_many :events, through: :invitees
  has_many :invitations_as_sender, foreign_key: :sender_id, inverse_of: :sender, dependent: :destroy
  has_many :invitations_as_recipient, foreign_key: :recipient_id, inverse_of: :recipient, dependent: :nullify
end
