# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :song, :user
  belongs_to :user

  validates :user, presence: true
  validates :song, presence: true
  # 表示名なのだが、20文字くらいあれば大丈夫な気がする。バックエンドではうるさいこと言っていないので後で変えてもよい
  validates :screen_name, presence: true, length: { maximum: 20 }
  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  # こいつは適当に140に設定しているが、別になんでもいい気もする。
  validates :comment, length: { maximum: 140 }
end
