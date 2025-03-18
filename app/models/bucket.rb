class Bucket < ApplicationRecord
  include Accessible, Broadcastable, Filterable, Subscribable

  belongs_to :account
  belongs_to :creator, class_name: "User", default: -> { Current.user }

  has_many :bubbles, dependent: :destroy
  has_many :tags, -> { distinct }, through: :bubbles

  validates_presence_of :name

  after_create :ensure_workflow_exists

  scope :alphabetically, -> { order(name: :asc) }

  private
    def ensure_workflow_exists
      unless account.workflows.exists?
        workflow = account.workflows.create!(name: "Default Workflow")
        [ "Maybe?", "Not now", "Done" ].each { |name| workflow.stages.create!(name: name) }
      end
    end
end
