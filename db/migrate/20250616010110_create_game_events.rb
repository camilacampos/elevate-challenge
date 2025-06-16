class CreateGameEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :game_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.string :event_type, null: false
      t.timestamp :occurred_at, null: false

      t.timestamps
    end
  end
end
