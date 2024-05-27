# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :source_report, class_name: 'Report'

  belongs_to :destination_report, class_name: 'Report'

  validates :destination_report_id, uniqueness: { scope: :source_report_id }
end
