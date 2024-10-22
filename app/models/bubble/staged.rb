module Bubble::Staged
  extend ActiveSupport::Concern

  included do
    belongs_to :stage, class_name: "Workflow::Stage", optional: true
  end

  def workflow
    stage&.workflow
  end

  def toggle_stage(stage)
    if self.stage == stage
      update! stage: nil
      track_event :unstaged, stage_id: stage.id
    else
      update! stage: stage
      track_event :staged, stage_id: stage.id
    end
  end
end
