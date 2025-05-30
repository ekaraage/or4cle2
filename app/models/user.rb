# frozen_string_literal: true

class User < ApplicationRecord
  validations :name, presence: true, limit: { maximum: 20 }
end
