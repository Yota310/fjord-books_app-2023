# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mention_source_report, class_name: 'Report', inverse_of: :mentioned_relation
  belongs_to :mention_destination_report, class_name: 'Report', inverse_of: :mentioning_relation

  validates :mention_destination_report_id, uniqueness: { scope: :mention_source_report_id }
end
