class ChangeDateColumnDataType < ActiveRecord::Migration[8.0]
  def change
    change_column :rankings, :start_date, :datetime, null: false
    change_column :rankings, :end_date, :datetime, null: false
  end
end
