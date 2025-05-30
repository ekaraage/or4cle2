# frozen_string_literal: true

class AddNotnullOnSongs < ActiveRecord::Migration[8.0]
  def up
    change_column :songs, :title, :string, null: false
    change_column :songs, :model, :string, null: false
  end

  def down
    change_column :songs, :title, :string, null: true
    change_column :songs, :model, :string, null: true
  end
end
