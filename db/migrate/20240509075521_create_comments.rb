class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :comment
      t.references :user, null: false, foreign_key: true
      t.references :book, null: true, foreign_key: true
      t.references :report, null: true, foreign_key: true

      t.timestamps
    end
  end
end
