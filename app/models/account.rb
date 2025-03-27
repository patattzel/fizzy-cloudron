class Account < ApplicationRecord
  include Joinable

  has_many :buckets, dependent: :destroy
  has_many :bubbles, through: :buckets

  has_many :users, dependent: :destroy do
    def system
      find_or_create_system_user(proxy_association.owner)
    end
  end

  has_many :workflows, dependent: :destroy
  has_many :stages, through: :workflows, class_name: "Workflow::Stage"

  has_many :tags, dependent: :destroy

  has_many_attached :uploads

  after_create :create_default_workflow

  private
    def create_default_workflow
      workflows.create!(name: "Default Workflow").tap do |workflow|
        [ "Triage", "In progress", "On Hold", "Review" ].each do |name|
          workflow.stages.create!(name: name)
        end
      end
    end
end
