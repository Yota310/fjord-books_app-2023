# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  # 本記事が言及するレポート(Source)
  has_many :mention_destination_relations, class_name: 'Mention', dependent: :destroy, inverse_of: :source_report, foreign_key: 'source_report_id'
  has_many :mention_destination_reports, through: :mention_destination_relations, source: :destination_report

  # 本記事に言及しているレポート(Destination)
  has_many :mention_source_relations, class_name: 'Mention', dependent: :destroy, inverse_of: :destination_report, foreign_key: 'destination_report_id'
  has_many :mention_source_reports, through: :mention_source_relations, source: :source_report

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
    mention_destination_relations.destroy_all
    mention_destination_ids.uniq.each do |destination_id|
      next if id.to_s == destination_id

      mention_destination_relations.create!(destination_report_id: destination_id)
    end
  end
end
