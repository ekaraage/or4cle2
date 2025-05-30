# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :timeoutable, authentication_keys: [:name]

  validates :name, uniqueness: true, presence: true, length: { maximum: 30 }
  validates :password, complex_password: true
end
