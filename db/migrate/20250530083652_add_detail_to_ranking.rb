class AddDetailToRanking < ActiveRecord::Migration[8.0]
  def change
    add_column :rankings, :detail, :text, null: true
  end
end
