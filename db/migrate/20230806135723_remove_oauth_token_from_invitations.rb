class RemoveOauthTokenFromInvitations < ActiveRecord::Migration[7.0]
  def change
    remove_column :invitations, :oauth_token
  end
end
