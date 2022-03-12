class AddStateToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :state, :string, null: false, default: 'pending'
  end
end
