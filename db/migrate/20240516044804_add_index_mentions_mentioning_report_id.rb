class AddIndexMentionsMentioningReportId < ActiveRecord::Migration[7.0]
  def change
    add_index :mentions,[:mention_source_report_id, :mention_destination_report_id], unique: true, name: 'index_on_mention_source_and_destination'
  end
end
