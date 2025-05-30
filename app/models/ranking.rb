# frozen_string_literal: true

class Ranking < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, limit: { maximum: 80 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  # ここの400文字もマジ適当
  validates :details, length: { maximum: 400 }
end
