class AddOwnerToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :owner, :boolean, default: false
  end
end
