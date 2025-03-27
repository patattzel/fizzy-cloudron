class AddWorkflowToBuckets < ActiveRecord::Migration[8.1]
  def change
    add_reference :buckets, :workflow, null: true, foreign_key: true
  end
end
