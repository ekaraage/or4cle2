# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :song
  belongs_to :user
  has_one_attached :image

  validates :user, presence: true
  validates :song, presence: true
  # 表示名なのだが、20文字くらいあれば大丈夫な気がする。バックエンドではうるさいこと言っていないので後で変えてもよい
  validates :screen_name, presence: true, length: { maximum: 20 }
  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  # こいつは適当に140に設定しているが、別になんでもいい気もする。
  validates :comment, length: { maximum: 140 }

  validate :image_content_type
  validate :image_size

  def image_content_type
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/png image/gif]) # rubocop:disable Style/GuardClause
      errors.add(:image, '画像の拡張子は JPEG, PNG, GIF のいずれかでなければなりません。')
    end
  end

  def image_size
    if image.attached? && image.byte_size > 2.megabytes # rubocop:disable Style/GuardClause
      errors.add(:image, '画像のサイズは2MB以下でなければなりません。')
    end
  end

  def submitted_by?(user)
    self.user == user
  end
end
