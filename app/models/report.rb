# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioned_relation, foreign_key: 'mention_destination_report_id', class_name: 'Mention', dependent: :destroy, inverse_of: :mention_source_report
  has_many :mentioned_reports, through: :mentioned_relation, source: :mention_source_report
  has_many :mentioning_relation, foreign_key: 'mention_source_report_id', class_name: 'Mention', dependent: :destroy, inverse_of: :mention_destination_report
  has_many :mentioning_reports, through: :mentioning_relation, source: :mention_destination_report

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
    mentioning_reports.destroy_all
    @urls = content.scan(%r{http://localhost:3000/reports/\d+})
    return if @urls.nil?

    @mentioned_ids = @urls.map! do |url|
      url.split('/').last
    end
    @mentioned_ids.uniq.each do |mentioned_id| # 言及先の変数
      Mention.create!(mention_destination_report_id: mentioned_id, mention_source_report_id: id)
    end
  end
end
