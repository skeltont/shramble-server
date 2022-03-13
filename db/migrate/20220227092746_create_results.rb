class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results, id: :uuid do |t|
      t.references :player, type: :uuid, index: true, foreign_key: true
      t.references :contestant, type: :uuid, index: true, foreign_key: true
      t.references :match, type: :uuid, index: true, foreign_key: true
      t.boolean :win, default: false
      t.boolean :pass, default: false
      t.timestamps
    end
  end
end
