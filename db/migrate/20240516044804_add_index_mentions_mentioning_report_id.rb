class AddIndexMentionsMentioningReportId < ActiveRecord::Migration[7.0]
  def change
    add_index :mentions,[:source_report_id, :destination_report_id], unique: true, name: 'index_on_mention_source_and_destination'
  end
end
