class AddWinningsToMatch < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :winnings, :decimal, null: false, precision: 10, scale: 2, default: 0.0
  end
end
