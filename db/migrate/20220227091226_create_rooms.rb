class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms, id: :uuid do |t|
      t.string :room_code, null: false
      t.timestamps
    end
  end
end
