# frozen_string_literal: true

class Ranking < ApplicationRecord
  belongs_to :user, optional: true
  has_many :songs, dependent: :destroy

  validates :title, presence: true, length: { maximum: 80 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  # ここの400文字もマジ適当
  validates :detail, length: { maximum: 400 }
end
