# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :book, optional: true
  belongs_to :report, optional: true
end
