# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  # 本記事が言及するレポート
  has_many :mention_source_relations, class_name: 'Mention', dependent: :destroy, inverse_of: :mention_destination_report, foreign_key: 'mention_destination_report_id'
  has_many :mentioning_reports, through: :mention_source_relations, source: :mention_destination_report

  # 本記事に言及しているレポート
  has_many :mention_destination_relations, class_name: 'Mention', dependent: :destroy, inverse_of: :mention_source_report, foreign_key: 'mention_source_report_id'
  has_many :mentioned_reports, through: :mention_destination_relations, source: :mention_source_report

  validates :title, presence: true
  validates :content, presence: true
  after_save :create_mention

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def create_mention
    urls = content.scan(%r{http://localhost:3000/reports/\d+})
    return if urls.empty?

    mention_destination_ids = urls.map do |url|
      url.split('/').last
    end
    mention_source_relations.destroy_all
    mention_destination_ids.uniq.each do |mention_destination_id|
      binding.irb
      mention_source_relations.create!(mention_destination_report_id: mention_destination_id)
    end
  end
end
