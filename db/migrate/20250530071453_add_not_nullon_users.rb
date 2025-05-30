# frozen_string_literal: true

class AddNotNullonUsers < ActiveRecord::Migration[8.0]
  def up
    change_column :users, :name, :string, null: false
  end

  def down
    change_column :users, :name, :string, null: true
  end
end
