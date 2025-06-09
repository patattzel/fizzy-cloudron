class CreateCollectionPublications < ActiveRecord::Migration[8.1]
  def change
    create_table :collection_publications do |t|
      t.references :collection, null: false, foreign_key: true, index: true
      t.string :key, index: { unique: true }

      t.timestamps
    end
  end
end
