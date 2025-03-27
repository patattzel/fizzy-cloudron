class Bucket < ApplicationRecord
  include Accessible, Broadcastable, Filterable, Subscribable

  belongs_to :account
  belongs_to :creator, class_name: "User", default: -> { Current.user }
  belongs_to :workflow, optional: true

  has_many :bubbles, dependent: :destroy
  has_many :tags, -> { distinct }, through: :bubbles

  validates_presence_of :name

  after_create :ensure_workflow_exists
  after_save :update_bubbles_workflow, if: :saved_change_to_workflow_id?

  scope :alphabetically, -> { order(name: :asc) }

  private
    def ensure_workflow_exists
      unless account.workflows.exists?
        workflow = account.workflows.create!(name: "Default Workflow")
        [ "Triage", "In progress", "Oh Hold", "Review" ].each { |name| workflow.stages.create!(name: name) }
      end
    end

    def update_bubbles_workflow
      if workflow
        first_stage = workflow.stages.first
        bubbles.update_all(stage_id: first_stage.id) if first_stage
      else
        bubbles.update_all(stage_id: nil)
      end
    end
end
