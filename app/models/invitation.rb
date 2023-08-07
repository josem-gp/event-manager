class Invitation < ApplicationRecord
  enum status: { pending: 0, accepted: 1, denied: 2 }

  # Associations
  belongs_to :event
  belongs_to :sender, class_name: "User", inverse_of: :sent_invitations
  belongs_to :recipient, class_name: "User", inverse_of: :received_invitations

  # Validations
  validates :url, presence: true

  # Callbacks
  after_create :set_expiration_date

  scope :not_expired, -> { where(expired: false) }
  scope :expired, -> { where(expired: true) }

  def pending?
    status == 'pending'
  end

  def accepted?
    status == 'accepted'
  end

  def denied?
    status == 'denied'
  end

  private

  def set_expiration_date
    self.expiration_date = 1.day.from_now
    save
  end
end
