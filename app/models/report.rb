# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  # 自身が引用されたレポートを持っていることをhas_manyで定義
  has_many :mentioned_relation, foreign_key: 'mention_destination_report_id', class_name: 'Mention', dependent: :destroy, inverse_of: :mention_source_report
  has_many :mentioned_reports, through: :mentioned_relation, source: :mention_source_report
  # 自信を引用したレポートを持っていることをhas_manyで定義
  has_many :mentioning_relation, foreign_key: 'mention_source_report_id', class_name: 'Mention', dependent: :destroy, inverse_of: :mention_destination_report
  has_many :mentioning_reports, through: :mentioning_relation, source: :mention_destination_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
