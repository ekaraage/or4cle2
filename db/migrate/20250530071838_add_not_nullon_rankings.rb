class AddNotNullonRankings < ActiveRecord::Migration[8.0]
  def up
    change_column :rankings, :title, :string, null: false
    change_column :rankings, :start_date, :time, null: false
    change_column :rankings, :end_date, :time, null: false
  end
  def down
    change_column :rankings, :title, :string, null: true
    change_column :rankings, :start_date, :time, null: true
    change_column :rankings, :end_date, :time, null: true
  end
end
