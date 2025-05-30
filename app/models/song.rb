# frozen_string_literal: true

class Song < ApplicationRecord
  belongs_to :ranking

  validates :ranking, presence: true
  validates :title, presence: true
  # これも適当に30文字にしている。バックエンドは何もしてないので後で変えること可能
  validates :model, presence: true, length: { maximum: 30 }
end
