class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :mention_source_report, null: false, foreign_key: { to_table: :reports }
      t.references :mention_destination_report, null: false, foreign_key: { to_table: :reports }

      t.timestamps
    end
  end
end
