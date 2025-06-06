# frozen_string_literal: true

class User < ApplicationRecord
  has_many :rankings, dependent: :destroy
  has_many :submissions, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :timeoutable, authentication_keys: [:name]

  validates :name, uniqueness: true, presence: true, length: { maximum: 30 },
                   format: { with: /\A[a-zA-Z0-9_]+\z/, message: 'は英数字とアンダースコアのみ使用できます。' }
  validates :password, complex_password: true

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def can_edit_song?(ranking)
    ranking.active? && ranking.made_by?(self)
  end

  def can_submit_score?(song)
    song.active? && song.submissions.find_by(user: self).nil?
  end

  def can_edit_submission?(submission)
    submission.song.active? && submission.submitted_by?(self)
  end
end
