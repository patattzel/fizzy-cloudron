class AddRollupReferenceToEvents < ActiveRecord::Migration[8.0]
  def up
    add_reference :events, :rollup, foreign_key: true
  end
end
