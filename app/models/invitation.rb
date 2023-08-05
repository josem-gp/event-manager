class Invitation < ApplicationRecord
  has_secure_token :oauth_token, length: 36 # Rails built-in method (https://api.rubyonrails.org/classes/ActiveRecord/SecureToken/ClassMethods.html#method-i-has_secure_token)

  # Associations
  belongs_to :event
  belongs_to :sender, class_name: "User", inverse_of: :sent_invitations
  belongs_to :recipient, class_name: "User", inverse_of: :received_invitations
end
