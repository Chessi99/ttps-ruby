class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.text :export_content, null: true
      t.belongs_to :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
