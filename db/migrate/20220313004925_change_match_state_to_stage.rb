class ChangeMatchStateToStage < ActiveRecord::Migration[7.0]
  def change
    rename_column :matches, :state, :stage
  end
end
