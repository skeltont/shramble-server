class ChangeRoomStateToStage < ActiveRecord::Migration[7.0]
  def change
    rename_column :rooms, :state, :stage
  end
end
