class CreateActionTextMarkdowns < ActiveRecord::Migration[8.0]
  def change
    create_table :action_text_markdowns do |t|
      t.references :record, polymorphic: true, null: false
      t.string :name, null: false
      t.text :content, null: false, default: ""
      t.timestamps
    end

    add_column :active_storage_attachments, :slug, :string
    add_index :active_storage_attachments, :slug, unique: true
  end
end
