class AddWorkflowStageToBubbles < ActiveRecord::Migration[8.0]
  def change
    add_reference :bubbles, :stage, null: true, foreign_key: { to_table: :workflow_stages }
  end
end
