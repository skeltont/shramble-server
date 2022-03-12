class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches, id: :uuid do |t|
      t.references :room, type: :uuid, index: true, foreign_key: true
      t.decimal :wager, precision: 10, scale: 2 # beeg
      t.timestamps
    end
  end
end
