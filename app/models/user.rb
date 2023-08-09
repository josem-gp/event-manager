class User < ApplicationRecord
  ALPHABETIC_REGEX = /\A[a-zA-Z]+\z/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Associations
  has_many :created_events, foreign_key: :creator_id, class_name: "Event", inverse_of: :creator, dependent: :destroy
  has_many :invitees, dependent: :destroy
  has_many :events, through: :invitees
  has_many :sent_invitations, foreign_key: :sender_id, class_name: "Invitation", inverse_of: :sender,
                              dependent: :destroy
  has_many :received_invitations, foreign_key: :recipient_id, class_name: "Invitation", inverse_of: :recipient,
                                  dependent: :nullify

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, format: { with: ALPHABETIC_REGEX, message: I18n.t('users.alphabetic_format') },
                                     on: :update

  # Callbacks
  before_update :prevent_email_update

  # If user does not exist, create it
  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
    end
  end

  def an_invitee?(event)
    Invitee.find_by(user: self, event:).present?
  end

  private

  def prevent_email_update
    errors.add(:email, 'cannot be updated') if email_changed?
    throw(:abort) if errors.present?
  end
end
