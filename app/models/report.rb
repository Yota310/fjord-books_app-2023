# frozen_string_literal: true

class Report < ApplicationRecord
  has_many :comments, dependent: :destroy, as: :commentable
  belongs_to :user
end
