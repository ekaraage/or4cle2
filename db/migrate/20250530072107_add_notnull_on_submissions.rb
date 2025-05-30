# frozen_string_literal: true

class AddNotnullOnSubmissions < ActiveRecord::Migration[8.0]
  def up
    change_column :submissions, :screen_name, :string, null: false
    change_column :submissions, :score, :integer, null: false
  end

  def down
    change_column :submissions, :screen_name, :string, null: true
    change_column :submissions, :score, :integer, null: true
  end
end
