module Card::Staged
  extend ActiveSupport::Concern

  included do
    belongs_to :stage, class_name: "Workflow::Stage", optional: true

    before_create :assign_initial_stage

    scope :in_stage, ->(stage) { where stage: stage }
  end

  def workflow
    stage&.workflow
  end

  def toggle_stage(stage)
    new_stage, event = self.stage_id == stage.id ? [ nil, :unstaged ] : [ stage, :staged ]

    transaction do
      update! stage: new_stage
      track_event event, stage_id: stage.id, stage_name: stage.name
    end
  end

  private
    def assign_initial_stage
      self.stage = collection.initial_workflow_stage
    end
end
