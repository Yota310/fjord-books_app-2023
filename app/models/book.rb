# frozen_string_literal: true

class Book < ApplicationRecord
  mount_uploader :picture, PictureUploader
  has_many :comments, dependent: :destroy, as: :commentable
end
