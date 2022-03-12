class AddStateToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :state, :string, null: false, default: 'active'
  end
end
