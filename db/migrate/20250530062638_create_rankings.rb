class CreateRankings < ActiveRecord::Migration[8.0]
  def change
    create_table :rankings do |t|
      t.string :title
      t.time :start_date
      t.time :end_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
