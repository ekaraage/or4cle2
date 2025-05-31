# frozen_string_literal: true

class Song < ApplicationRecord
  belongs_to :ranking
  has_many :submissions, dependent: :destroy

  validates :ranking, presence: true
  validates :title, presence: true
  # これも適当に30文字にしている。バックエンドは何もしてないので後で変えること可能
  validates :model, presence: true, length: { maximum: 30 }

  # Songとuserの関連付けが適当なので、Rankingを作った人しか曲を追加できない仕様ということにした
  def added_by?(user)
    ranking.user == user
  end
end
