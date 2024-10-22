class CreateWorkflowStages < ActiveRecord::Migration[8.0]
  def change
    create_table :workflow_stages do |t|
      t.references :workflow, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
