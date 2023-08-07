class RemoveAcceptedFromInvitations < ActiveRecord::Migration[7.0]
  def change
    remove_column :invitations, :accepted
  end
end
