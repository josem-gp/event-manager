class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.string :url, null: false
      t.boolean :accepted, default: false
      t.boolean :expired, default: false
      t.text :oauth_token, null: false
      t.datetime :expiration_date, null: false
      t.references :event, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users}
      t.references :recipient, null: true, foreign_key: { to_table: :users} # If user is deleted, recipient can be null

      t.timestamps
    end
  end
end
