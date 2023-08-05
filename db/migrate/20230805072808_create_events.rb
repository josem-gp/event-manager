class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :date, null: false
      t.integer :time, default: 60 # The duration of the event will default to 60 min according to specifications
      t.references :creator, null: false, foreign_key: { to_table: :users}

      t.timestamps
    end
  end
end
