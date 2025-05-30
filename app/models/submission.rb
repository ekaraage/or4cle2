# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :song
  belongs_to :user
end
