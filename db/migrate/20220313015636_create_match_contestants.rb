class CreateMatchContestants < ActiveRecord::Migration[7.0]
  def change
    create_table :match_contestants do |t|
      t.references :match, type: :uuid, index: true, foreign_key: true
      t.references :contestant, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
  end
end
