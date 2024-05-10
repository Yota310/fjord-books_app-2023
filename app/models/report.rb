# frozen_string_literal: true

class Report < ApplicationRecord
  has_many :comment, dependent: :destroy
  belongs_to :user
end
