module Bubble::Draftable
  extend ActiveSupport::Concern

  included do
    enum :status, %w[ creating drafted published ].index_by(&:itself)

    scope :published_or_drafted_by, ->(user) { where(status: :published).or(where(status: :drafted, creator: user)) }
  end

  def publish
    transaction do
      published!
      track_event :published

      if assignments.any?
        track_event :assigned, assignee_ids: assignee_ids
      end
    end
  end
end
