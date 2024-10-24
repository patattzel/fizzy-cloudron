class AddRollupReferenceToEvents < ActiveRecord::Migration[8.0]
  def up
    # FIXME: add null: false in another migration after data migrations happen
    add_reference :events, :rollup, foreign_key: true
  end
end
