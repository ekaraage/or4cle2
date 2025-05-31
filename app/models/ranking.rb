# frozen_string_literal: true

class Ranking < ApplicationRecord
  belongs_to :user, optional: true
  has_many :songs, dependent: :destroy

  validates :title, presence: true, length: { maximum: 80 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  # ここの400文字もマジ適当
  validates :detail, length: { maximum: 400 }

  def formatted_date
    "#{start_date.strftime('%Y/%m/%d %H:%M')} ~ #{end_date.strftime('%Y/%m/%d %H:%M')}"
  end

  def active?
    Time.current.between?(start_date, end_date)
  end
end
