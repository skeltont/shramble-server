class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players, id: :uuid do |t|
      t.string :name, null: false
      t.references :room, type: :uuid, index: true, foreign_key: true
      t.timestamps
    end
  end
end
