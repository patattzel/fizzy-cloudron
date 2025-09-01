class CreatePeriodHighlights < ActiveRecord::Migration[8.1]
  def change
    create_table :period_highlights do |t|
      t.datetime :starts_at, null: false
      t.bigint :duration, null: false, default: 1.week.to_i
      t.string :key, null: false
      t.text :content, null: false
      t.bigint :cost_in_microcents

      t.index %i[ key starts_at duration ] , unique: true

      t.timestamps
    end
  end
end
