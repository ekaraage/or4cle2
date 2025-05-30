# frozen_string_literal: true

class CreateSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :model
      t.references :ranking, null: false, foreign_key: true

      t.timestamps
    end
  end
end
