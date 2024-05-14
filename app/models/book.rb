# frozen_string_literal: true

class Book < ApplicationRecord
  has_one_attached :image
end
